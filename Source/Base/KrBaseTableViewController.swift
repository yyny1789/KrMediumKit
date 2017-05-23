//
//  BaseTableViewController.swift
//  Client
//
//  Created by paul on 16/8/1.
//  Copyright © 2016年 36Kr. All rights reserved.
//

import UIKit
import Moya
import ObjectMapper

fileprivate var BaseTableViewControllerContext = 0

open class KrBaseTableViewController: KrBaseViewController, UITableViewDelegate, UITableViewDataSource {

    open var tableView: UITableView!
    
    open var reloadEnabled: Bool {
        return true
    }
    open var loadMoreEnabled: Bool {
        return true
    }

    // MARK: Lifecycle
    
    deinit {
        tableView.delegate = nil
        tableView.dataSource = nil
        tableView.removeLoadmore()
        tableView.removePullToRefresh()
        tableView.removeObserver(self, forKeyPath: "contentSize", context: &BaseTableViewControllerContext)
    }
    
    init(tableView: UITableView) {
        super.init(nibName: nil, bundle: nil)
        commonInit(tableView)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        commonInit(nil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func commonInit(_ tableView: UITableView?) {
        if tableView == nil {
            self.tableView = UITableView(frame: CGRect.zero, style: UITableViewStyle.plain)
        } else {
            self.tableView = tableView
        }
        self.tableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: &BaseTableViewControllerContext)
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = UIColor(hex: 0xf0f0f0)
        tableView.separatorInset = UIEdgeInsetsMake(0, 20, 0, 20)
        tableView.tableFooterView = UIView()
        if reloadEnabled {
            tableView.setupPullToRefresh { [weak self] in
                self?.refreshData()
            }
        }
        registerCell()
        loadingState = .loading
        loadingData()
    }
    
    // MARK: Layout
    
    override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = CGRect(x: 0, y: 0, width: view.width, height: view.height)
    }
    
    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if context == &BaseTableViewControllerContext {
            if keyPath == "contentSize" &&
                loadMoreEnabled &&
                tableView.loadmore == nil &&
                tableView.contentSize.height > (tableView.height - tableView.contentInset.top) && tableView.height > 0 &&
                tableView.refresher?.state != .loading {
                tableView.setupLoadmore(action: { [weak self] in
                    self?.loadMoreData()
                    })
            }
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }

    
    override open func loadingData() {
        refreshData()
    }
    
    open func refreshData() {
        assertionFailure("must override this")
    }
    
    open func loadMoreData() {
        assertionFailure("must override this")
    }
    
    open func reloadTableView() {
        tableView.reloadData()
    }
    
    open func registerCell() {
        assertionFailure("must override this")
    }
    
    open func triggerRefresh() {
        self.tableView.refresher?.startRefreshing()
    }
    
    // MARK: UITableViewDataSource
    
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    public func requestList<T: TargetType, O: Mappable>(_ target: T, stub: Bool = false, log: Bool = false, success: @escaping (_ result: ListResponse<O>) -> Void, failure: @escaping (_ error: MoyaError) -> Void) {
        
        _ = NetworkManager.manager.request(target, stub: stub, log: log, success: { (aResult: ListResponse<O>) in
            if self.loadMoreEnabled {
                if let count = aResult.data?.count {
                    if count > 0 {
                        self.tableView.endLoadmore(hasMore: true)
                    } else {
                        self.tableView.endLoadmore(hasMore: false)
                    }
                } else {
                    self.tableView.endLoadmore(hasMore: false)
                }
            }
            success(aResult)
        }) { (error) in
            failure(error)
        }
    }
    
}


