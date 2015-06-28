//
//  UILabel+Additions.swift
//  iAugus
//
//  Created by Augus on 6/7/15.
//  Copyright (c) 2015 Augus. All rights reserved.
//

import Foundation

// calculate size of UILabel with string
func ausFrameSizeForText(text: NSString, font: UIFont, maximumSize: CGSize) -> CGRect{
    let attrString = NSAttributedString(string: text as String)
    return attrString.boundingRectWithSize(maximumSize, options: NSStringDrawingOptions.UsesLineFragmentOrigin, context: nil)
    
}

func ausFrameSizeForText(label: UILabel, text: NSString, maximum: CGSize) -> CGRect{
    label.attributedText = NSAttributedString(string: text as String)
    let maximumLabelSize = maximum
    let requireSize = label.sizeThatFits(maximumLabelSize)
    var labelFrame = label.frame
    labelFrame.size.height = requireSize.height
    label.frame = labelFrame
    return label.frame
}