//
//  HomeViewController.swift
//  iAugus
//
//  Created by Augus on 4/25/15.
//  Copyright (c) 2015 Augus. All rights reserved.
//

import UIKit
import GearRefreshControl


class HomeViewController: UITableViewController {
    var gearRefreshControl: GearRefreshControl!
    
    var statuses:NSMutableArray? = NSMutableArray()
    var query:WeiboRequestOperation? = WeiboRequestOperation()
    let refreshController = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println("")
        // part of GearRefreshController
        gearRefreshControl = GearRefreshControl(frame: self.view.bounds)
        gearRefreshControl.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl = gearRefreshControl
        self.refreshControl?.beginRefreshing()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        var loginOrLogoutButton = UIBarButtonItem()
        
        if !(Weibo.getWeibo().isAuthenticated()){
            showLoginButton()
        }
        else {
            showLogoutButton()
        }
        self.loadstatuses()
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
            self.loadstatuses()
        }
        else{
            println("has already been authenticated!")
            self.loadstatuses()
        }
        self.loadstatuses()
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
    
    
    // MARK: - load data of weibo timeline
    func loadstatuses(){
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
    
    
    // MARK: - table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
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
        let cell = UITableViewCell(style: .Default, reuseIdentifier: "TimelineCell")

        if statuses != nil{
            let status:Status = statuses?.objectAtIndex(indexPath.row) as! Status
            cell.textLabel?.text = status.text
        }
        return cell
    }
    
    // MARK: - part of GearRefreshControl
    func refresh(){
        var popTime = dispatch_time(DISPATCH_TIME_NOW, Int64(3.0 * Double(NSEC_PER_SEC)));
        dispatch_after(popTime, dispatch_get_main_queue()) { () -> Void in
            self.loadstatuses()
            self.gearRefreshControl.endRefreshing()
        }
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        gearRefreshControl.scrollViewDidScroll(scrollView)
    }
    
}
