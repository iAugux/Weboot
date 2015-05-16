//
//  MainViewController.swift
//  iAugus
//
//  Created by Augus on 4/25/15.
//  Copyright (c) 2015 Augus. All rights reserved.
//

import UIKit


class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        initViewController()
        
        // set defalut viewController of TabBarViewController
        self.selectedIndex = 2
        
        doubleClickTarBarToRefresh()
    }
    
    
    private func initViewController(){
        let homeViewController = HomeViewController()
        let commentViewController = CommentViewController()
        let favoriteViewController = FavoriteViewController()
        let atViewController = AtViewController()
        let profileViewController = ProfileViewController()
        
    }
 
    func doubleClickTarBarToRefresh(){
        if tabBarItem == self.selectedIndex {
            

        }
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "beginToRefresh")
        tapGesture.numberOfTapsRequired = 2
        
    }
    
    func beginToRefresh(){
        println("double Clicked")
    }
    
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
