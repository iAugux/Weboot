//
//  HomeViewController.swift
//  iAugus
//
//  Created by Augus on 4/25/15.
//  Copyright (c) 2015 Augus. All rights reserved.
//

import UIKit
import GearRefreshControl
import Alamofire


class HomeViewController: UITableViewController {
    var gearRefreshControl: GearRefreshControl!
    var statuses: NSMutableArray?
    var users: NSMutableArray?
    var query:WeiboRequestOperation? = WeiboRequestOperation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadStatuses()
        // set navigationItem' title to name of currentAccount
        let nameOfCurrentAccount = Weibo.getWeibo().currentAccount().user.name
        self.navigationItem.title = nameOfCurrentAccount
        
        // part of GearRefreshController
        gearRefreshControl = GearRefreshControl(frame: self.view.bounds)
        gearRefreshControl.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl = gearRefreshControl
        
        // register weibo cell
        tableView.rowHeight = 250.0
        tableView.registerNib(UINib(nibName: "OriginalWeiboTableViewCell", bundle: nil), forCellReuseIdentifier: "OriginalWeiboTableViewCell")
        
    }
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        if !(Weibo.getWeibo().isAuthenticated()){
            showLoginButton()
        }
        else {
            showLogoutButton()
        }
        tableView.reloadData()
    }
    
    // MARK: - login or logout
    
    func showLoginButton(){
        let loginButton = UIBarButtonItem(title: "Login", style: UIBarButtonItemStyle.Plain, target: self, action: "loginWeibo")
        self.navigationItem.rightBarButtonItem = loginButton
    }
    func showLogoutButton(){
        let logoutButton = UIBarButtonItem(title: "Logout", style: .Plain, target: self, action: "logoutWeibo")
        self.navigationItem.rightBarButtonItem = logoutButton
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    func loginWeibo(){
        
        if !(Weibo.getWeibo().isAuthenticated()){
            println("not authenticated! and authenticating...")
            Weibo.getWeibo().authorizeWithCompleted({ account, error in
                if error == nil{
                    NSLog("sign in successful \(account.user.screenName)")
                    println("sign in successful")
                    
                }
                else{
                    NSLog("failed to sign in \(error)")
                    println("failed to sign in ")
                }
            })
            self.loadStatuses()
        }
        else{
            println("has already been authenticated!")
            self.loadStatuses()
        }
        self.loadStatuses()
        
    }
    
    func logoutWeibo(){
        let alertController = UIAlertController(title: "Log Out", message: "Are you sure to logout", preferredStyle: UIAlertControllerStyle.Alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil)
        let confirmAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {
            action in
            Weibo.getWeibo().signOut()
            self.tableView.dataSource = nil
            self.tableView.reloadData()
        })
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
   
    // MARK: - load data
    func loadStatuses(){
        self.statuses = nil
        if query != nil {
            query!.cancel()
        }
        self.tableView.reloadData()
        query = Weibo.getWeibo().queryTimeline(StatusTimelineFriends, count: numberOfTimelineRow , completed: ({ statuses, error in
            if error != nil{
                self.statuses = nil
                NSLog("error: \(error) , please login...")
                
            }
            else{
                self.statuses = statuses
            }
            self.query = nil
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
        }))
        
    }

    // MARK: - TableViewDataSource
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if query != nil {
            return 1
        }
        if self.statuses == nil{
            return 1
        }
        return statuses!.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let identifier: String = "OriginalWeiboTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier) as! OriginalWeiboTableViewCell
        if statuses != nil{
            let status: Status = statuses?.objectAtIndex(indexPath.row) as! Status
            
            // set weibo text
            cell.originalWeiboText.text = status.text
            
            // set created time
            cell.createdDate.text = status.statusTimeString()
            
            //set weibo source
            cell.weiboSource.text = status.source
            
            // set ScreenName
            cell.screenName.text = status.user.screenName
            
            // set user image
            if let userImageUrl = status.user.profileImageUrl{
                Alamofire.request(.GET, userImageUrl).response(){
                    (_, _, data, _) in
                    let image = UIImage(data: data! as! NSData)
                    cell.userImage.image = image
                }
            }
            
            // set original weibo images
//            if let arrayImageUrl: NSArray = status.images{
//                Alamofire.request(.GET, arrayImageUrl).response(){
//                    (_, _, [data], _) in
//                    
//                }
//            }
//            let originalImageUrl = status.images
//            println("\(originalImageUrl)")
//            cell.imageView?.image =
            
        }
//        self.tableView.setContentOffset(CGPointMake(0, -10.0), animated: true)

        return cell
    }
    
    // MARK: - part of GearRefreshControl
    func refresh(){
        var popTime = dispatch_time(DISPATCH_TIME_NOW, Int64(3.0 * Double(NSEC_PER_SEC)));
        dispatch_after(popTime, dispatch_get_main_queue()) { () -> Void in
            self.loadStatuses()
            self.gearRefreshControl.endRefreshing()
        }
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        gearRefreshControl.scrollViewDidScroll(scrollView)
    }
    
}
