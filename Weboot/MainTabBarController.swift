//
//  MainViewController.swift
//  iAugus
//
//  Created by Augus on 4/25/15.
//  Copyright (c) 2015 Augus. All rights reserved.
//

import UIKit


class MainTabBarController: UITabBarController {

    var mainVCBackgrounderButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.changeStatusBarColorOnSwipe()

//        self.tabBar.frame = CGRectMake(0 , kScreenHeight - 46 , kScreenWidth ,HEIGHT_OF_TAB_BAR)
        
        // set defalut viewController of TabBarViewController
        self.selectedIndex = 2
        
        
        
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
            mainVCBackgrounderButton?.frame = self.view.frame

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

    }
   
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        /**
        important: if present NavigationController's property of interactivePopGestureRecognizer is enable, we must set it to disable,
        otherwise if we call UIScreenEdgePanGestureRecognizer on present ViewController it will crash.
        */
//        self.navigationController?.interactivePopGestureRecognizer?.enabled = false
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
 
//    // after swiping, navigation bar has  been hidden, but background color of status bar is clearColor, so I need to set status bar' color to blur
//    func changeStatusBarColorOnSwipe(){
//        let statusBarView: UIToolbar = UIToolbar(frame: CGRectMake(0, 0, kScreenWidth, 22))
//        statusBarView.barStyle = UIBarStyle.Default
////        statusBarView.barTintColor = UIColor.redColor()
//    
//        self.view.addSubview(statusBarView)
//    }
   

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
 
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
