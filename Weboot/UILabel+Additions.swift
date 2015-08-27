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

//class DiaryLabel: UILabel {
//    
//    var textAttributes: [NSObject : AnyObject]!
//    
//    convenience init(fontname:String,
//        labelText:String,
//        fontSize : CGFloat,
//        lineHeight: CGFloat){
//            
//            self.init(frame: CGRectZero)
//            
//            let font = UIFont(name: fontname,
//                size: fontSize) as UIFont!
//            
//            var paragraphStyle = NSMutableParagraphStyle()
//            paragraphStyle.lineSpacing = lineHeight
//            
//            textAttributes = [NSFontAttributeName: font,
//                NSParagraphStyleAttributeName: paragraphStyle]
//            
//            var labelSize = sizeHeightWithText(labelText,
//                fontSize: fontSize ,textAttributes: textAttributes)
//            
//            self.frame = CGRectMake(0, 0, labelSize.width,
//                labelSize.height)
//            
//            self.attributedText = NSAttributedString(string: labelText,
//                attributes: textAttributes)
//            self.lineBreakMode = NSLineBreakMode.ByCharWrapping
//            self.numberOfLines = 0
//    }
//    
//    func sizeHeightWithText(labelText: NSString,
//        fontSize: CGFloat,
//        textAttributes: [NSObject : AnyObject]) -> CGRect {
//            
//            return labelText.boundingRectWithSize(CGSizeMake(fontSize, 480),
//                options: NSStringDrawingOptions.UsesLineFragmentOrigin,
//                attributes: textAttributes, context: nil)
//    }
//    
//    func resizeLabelWithFontName(fontname:String,
//        labelText:String,
//        fontSize : CGFloat,
//        lineHeight: CGFloat ){
//            let font = UIFont(name: fontname, size: fontSize) as UIFont!
//            
//            var paragraphStyle = NSMutableParagraphStyle()
//            paragraphStyle.lineSpacing = lineHeight
//            
//            textAttributes = [NSFontAttributeName: font,
//                NSForegroundColorAttributeName: UIColor.blackColor(),
//                NSParagraphStyleAttributeName: paragraphStyle]
//            
//            var labelSize = sizeHeightWithText(labelText, fontSize: fontSize ,textAttributes: textAttributes)
//            
//            self.frame = CGRectMake(0, 0, labelSize.width, labelSize.height)
//            
//            self.attributedText = NSAttributedString(string: labelText,
//                attributes: textAttributes)
//            
//            self.lineBreakMode = NSLineBreakMode.ByCharWrapping
//            self.numberOfLines = 0
//    }
//    
//    func updateText(labelText: String) {
//        
//        var labelSize = sizeHeightWithText(labelText,fontSize: self.font.pointSize, textAttributes: textAttributes)
//        
//        self.frame = CGRectMake(0, 0, labelSize.width, labelSize.height)
//        
//        self.attributedText = NSAttributedString(string: labelText,
//            attributes: textAttributes)
//    }
//    
//    func updateLabelColor(color: UIColor) {
//        
//        textAttributes[NSForegroundColorAttributeName] = color
//        
//        self.attributedText = NSAttributedString(
//            string: self.attributedText.string,
//            attributes: textAttributes)
//    }
//    
//}