//
//  UIScreen+Additions.swift
//  iBBS
//
//  Created by Augus on 9/8/15.
//  Copyright © 2015 iAugus. All rights reserved.
//

import Foundation

extension UIScreen {
    class func screenWidth() -> CGFloat {
        return UIScreen.mainScreen().bounds.width
    }
    
    class func screenHeight() -> CGFloat {
        return UIScreen.mainScreen().bounds.height
    }
}