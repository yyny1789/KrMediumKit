//
//  UIView+TapGestureRecognizer.swift
//  Client
//
//  Created by 杨洋 on 17/3/30.
//  Copyright © 2017年 36Kr. All rights reserved.
//

import Foundation
import UIKit

public extension UIView {
    typealias TapResponseClosure = (_ tap: UITapGestureRecognizer) -> Void
    
    fileprivate struct ClosureStorage {
        static var TapClosureStorage: [UITapGestureRecognizer : TapResponseClosure] = [:]
    }
    
    public func addSingleTapGestureRecognizerWithResponder(_ responder: @escaping TapResponseClosure) {
        self.addTapGestureRecognizerForNumberOfTaps(responder)
    }
    
    public func addTapGestureRecognizerForNumberOfTaps(_ responder: @escaping TapResponseClosure) {
        let tap = UITapGestureRecognizer()
        tap.addTarget(self, action: #selector(UIView.handleTapGesture(_:)))
        self.addGestureRecognizer(tap)
        
        ClosureStorage.TapClosureStorage[tap] = responder
    }
    
    func handleTapGesture(_ sender: UITapGestureRecognizer) {
        if let closureForTap = ClosureStorage.TapClosureStorage[sender] {
            closureForTap(sender)
        }
    }
}
