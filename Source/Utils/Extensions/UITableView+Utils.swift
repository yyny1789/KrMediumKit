//
//  UITableView+Utils.swift
//  Client
//
//  Created by paul on 17/2/6.
//  Copyright © 2017年 36Kr. All rights reserved.
//

import Foundation
import UIKit

// 用于autolayout布局的tableHeaderView&&tableFooterView根据展示内容自适应高度
public extension UITableView {
    
    fileprivate func sizeViewToFit(_ view: UIView?) {
        guard let view = view else {
            return
        }
        let height = view.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
        var frame = view.frame
        frame.size.height = height
        view.frame = frame
        view.setNeedsLayout()
        view.layoutIfNeeded()
    }
    
    public func sizeHeaderViewToFit(_ headerView: UIView) {
        sizeViewToFit(tableHeaderView)
        tableHeaderView = headerView
    }
    
    public func sizeFooterViewToFit(_ footerView: UIView) {
        sizeViewToFit(tableFooterView)
        tableFooterView = footerView
    }
    
}
