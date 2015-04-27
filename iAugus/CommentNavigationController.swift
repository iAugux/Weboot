//
//  CommentNavigationController.swift
//  iAugus
//
//  Created by Augus on 4/26/15.
//  Copyright (c) 2015 Augus. All rights reserved.
//

import UIKit

class CommentNavigationController: BaseNavigationController {
    @IBOutlet weak var commentTabBarItem: UITabBarItem!
    
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        commentTabBarItem.title = "✯"
//    
//    }
    
    
    override func viewDidAppear(animated: Bool) {
        commentTabBarItem.title = "✯"
    }
    override func viewWillDisappear(animated: Bool) {
        commentTabBarItem.title = ""
    }
 
    
}
