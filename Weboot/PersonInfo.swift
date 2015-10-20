//
//  PersonInfo.swift
//  Weboot
//
//  Created by Augus on 10/19/15.
//  Copyright © 2015 iAugus. All rights reserved.
//

import Foundation


class PersonInfo: NSObject {
    var stringArray: NSMutableArray!
    
    func srcStringArray() -> NSArray {
        if stringArray != nil {
            stringArray = NSMutableArray()
        }
        return stringArray
    }
    
}