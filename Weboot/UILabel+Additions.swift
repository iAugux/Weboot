//
//  UILabel+Additions.swift
//  iAugus
//
//  Created by Augus on 6/7/15.
//  Copyright (c) 2015 Augus. All rights reserved.
//

import UIKit

// calculate size of UILabel with string
func ausFrameSizeForText(text: NSString, maximumSize: CGSize) -> CGRect{
    let attrString = NSAttributedString(string: text as String)
    return attrString.boundingRectWithSize(maximumSize, options: NSStringDrawingOptions.UsesLineFragmentOrigin, context: nil)
    
}

func ausFrameSizeForText(text: NSString, font: UIFont, maximumSize: CGSize) -> CGRect{
    return text.boundingRectWithSize(maximumSize, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
}

func ausFrameSizeForText(label: UILabel, text: NSString, maximum: CGSize) -> CGRect{
    label.attributedText = NSAttributedString(string: text as String)
    let requireSize = label.sizeThatFits(maximum)
    var labelFrame = label.frame
    labelFrame.size.height = requireSize.height
    label.frame = labelFrame
    return label.frame
}


extension UILabel {
    
    /**
    Methods to allow using HTML code with CoreText
    
    */
    func ausAttributedText(data: String) {
        do {
            let formatedData = data.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            let text = try NSAttributedString(data: formatedData.dataUsingEncoding(NSUnicodeStringEncoding,allowLossyConversion: false)!,
                options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
                documentAttributes: nil)
            self.attributedText = text
        }catch{
            print("something error with NSAttributedString")
        }
    }
}
