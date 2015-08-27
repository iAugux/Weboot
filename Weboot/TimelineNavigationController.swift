//
//  TimelineNavigationController.swift
//  iAugus
//
//  Created by Augus on 4/26/15.
//  Copyright (c) 2015 Augus. All rights reserved.
//

import UIKit

class TimelineNavigationController: BaseNavigationController {
    
    @IBOutlet weak var homeTabBarItem: UITabBarItem!
    
    
    override func viewDidAppear(animated: Bool) {
        homeTabBarItem.title = "✯"
    }
    override func viewWillDisappear(animated: Bool) {
        homeTabBarItem.title = ""
    }
    
    
}
