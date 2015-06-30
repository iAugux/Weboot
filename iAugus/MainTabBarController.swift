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
<<<<<<< HEAD
//        self.changeStatusBarColorOnSwipe()

//        self.tabBar.frame = CGRectMake(0 , kScreenHeight - 46 , kScreenWidth ,HEIGHT_OF_TAB_BAR)
=======
        self.changeStatusBarColorOnSwipe()

        self.tabBar.frame = CGRectMake(0 , kScreenHeight - 46 , kScreenWidth ,46)
>>>>>>> origin/master
        
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
    private func initViewController(){
        let homeViewController = HomeViewController()
        let commentViewController = CommentViewController()
        let favoriteViewController = FavoriteViewController()
        let atViewController = AtViewController()
        let profileViewController = ProfileViewController()
        
    }
 
<<<<<<< HEAD
//    // after swiping, navigation bar has  been hidden, but background color of status bar is clearColor, so I need to set status bar' color to blur
//    func changeStatusBarColorOnSwipe(){
//        let statusBarView: UIToolbar = UIToolbar(frame: CGRectMake(0, 0, kScreenWidth, 22))
//        statusBarView.barStyle = UIBarStyle.Default
////        statusBarView.barTintColor = UIColor.redColor()
//    
//        self.view.addSubview(statusBarView)
//    }
=======
    // after swiping, navigation bar has  been hidden, but background color of status bar is clearColor, so I need to set status bar' color to blur
    func changeStatusBarColorOnSwipe(){
        let statusBarView: UIToolbar = UIToolbar(frame: CGRectMake(0, 0, kScreenWidth, 22))
        statusBarView.barStyle = UIBarStyle.Default
//        statusBarView.barTintColor = UIColor.redColor()
    
        self.view.addSubview(statusBarView)
    }
>>>>>>> origin/master
   

    
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
