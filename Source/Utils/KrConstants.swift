//
//  KrConstants.swift
//  KitDemo
//
//  Created by 杨洋 on 2017/5/19.
//  Copyright © 2017年 com.36kr. All rights reserved.
//

import Foundation

// MARK: - Some methods

public func rangeFromNSRange(_ nsRange: NSRange, forString str: String) -> Range<String.Index>? {
    guard
        let from16 = str.utf16.index(str.utf16.startIndex, offsetBy: nsRange.location, limitedBy: str.utf16.endIndex),
        let to16 = str.utf16.index(str.utf16.startIndex, offsetBy: nsRange.location + nsRange.length, limitedBy: str.utf16.endIndex),
        let from = from16.samePosition(in: str),
        let to = to16.samePosition(in: str)
        else { return nil }
    return from ..< to
}
