//
//  UILabel+Utils.swift
//  Client
//
//  Created by aidenluo on 22/12/2016.
//  Copyright © 2016 36Kr. All rights reserved.
//

import UIKit

public extension UILabel {
    
    //生成设计稿上标准的行间距为5.0的效果
    public func setDesignText(_ text: String, textAlignment: NSTextAlignment = .left, lineBreakMode: NSLineBreakMode = .byTruncatingTail) {
        self.text = text
        setLineSpacingAndParagraphSpacing(5.0, paragraphSpacing: 10.0, textAlignment: textAlignment, lineBreakMode: lineBreakMode)
    }
    
    public func setLineSpacing(_ lineSpacing: CGFloat, textAlignment: NSTextAlignment = .left, lineBreakMode: NSLineBreakMode = .byTruncatingTail) {
        setLineSpacingAndParagraphSpacing(lineSpacing, paragraphSpacing: 0, textAlignment: textAlignment, lineBreakMode: lineBreakMode)
    }
    
    public func setLineSpacingAndParagraphSpacing(_ lineSpacing: CGFloat, paragraphSpacing: CGFloat, textAlignment: NSTextAlignment, lineBreakMode: NSLineBreakMode = .byTruncatingTail) {
        let text = self.text
        if let text = text {
            let attributeString = NSMutableAttributedString(string: text)
            let style = NSMutableParagraphStyle()
            if lineSpacing > 0 {
                style.lineSpacing = lineSpacing
            }
            if paragraphSpacing > 0 {
                style.paragraphSpacing = paragraphSpacing
                style.lineBreakMode = lineBreakMode
            }
            style.alignment = textAlignment
            attributeString.addAttribute(NSParagraphStyleAttributeName, value: style, range: NSMakeRange(0, text.characters.count))
            self.attributedText = attributeString
        }
    }
}
