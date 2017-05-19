//
//  SequenceType+Utils.swift
//  Tou
//
//  Created by 杨洋 on 17/2/9.
//  Copyright © 2017年 36kr. All rights reserved.
//

import Foundation

public extension Sequence {
    
    public func findElement(_ match: (Iterator.Element)->Bool) -> Iterator.Element? {
        for element in self where match(element) {
            return element
        }
        return nil
    }
    
}
