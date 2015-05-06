//
//  HomeViewController.swift
//  iAugus
//
//  Created by Augus on 4/25/15.
//  Copyright (c) 2015 Augus. All rights reserved.
//

import UIKit


class HomeViewController: BaseViewController {
    // MARK: - Property
    var statuses:NSMutableArray?
    var query:WeiboRequestOperation? = WeiboRequestOperation()
    var tableView:UITableView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println("accessToke: \(WeiboAuthentication().accessToken)")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        var loginAndLogoutButton = UIBarButtonItem()
        self.navigationItem.rightBarButtonItem?.title = ""
        
        
        
        if !(Weibo.getWeibo().isAuthenticated()){
            println("not been authenticated")
            loginAndLogoutButton = UIBarButtonItem(title: "Login", style: UIBarButtonItemStyle.Plain, target: self, action: "loginWeibo")
            self.navigationItem.rightBarButtonItem = loginAndLogoutButton
            println("authenticating...")
        }
        if Weibo.getWeibo().isAuthenticated(){
            println("has been authenticated")
            self.navigationItem.rightBarButtonItem?.title = ""
            loginAndLogoutButton = UIBarButtonItem(title: "Logout", style: .Plain, target: self , action: "logoutWeibo")
            self.navigationItem.rightBarButtonItem = loginAndLogoutButton

        }
       
    }
   
    func callWeibo() {
        println("weibo pressed")
        var request: WBAuthorizeRequest! = WBAuthorizeRequest.request() as! WBAuthorizeRequest
        request.redirectURI = "https://api.weibo.com/oauth2/default.html"
        request.scope = "all"
        WeiboSDK.sendRequest(request)
        println("accessToke: \(WeiboAuthentication().accessToken)")
        
        if Weibo.getWeibo().isAuthenticated(){
            self.loadstatuses()
        }
        
    }
    
    func loginWeibo(){
        
        if !(Weibo.getWeibo().isAuthenticated()){
            println("not authenticated")
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
            
        }else{
            println("has been authenticated")
            self.loadstatuses()
        }
        
    }
   
 
    
    func loadstatuses(){
        self.statuses = nil
        if let query = query{
            query.cancel()
        }
        self.tableView?.reloadData()
        query = Weibo.getWeibo().queryTimeline(StatusTimelineFriends, count: 50 , completed: ({ statuses, error in
            if error == nil{
                self.statuses = nil
                NSLog("error: \(error)")
                
            }
            else{
                self.statuses = statuses
                
            }
            self.query = nil
            self.tableView?.reloadData()
        }))

    }
    
    
    
    // MARK: - tableView
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if let query = query{
            return 1
        }
        if self.statuses == nil{
            return 1
        }
        return statuses!.count
    }
    
   
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cellIdentifier = "Cell"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! UITableViewCell
        cell = UITableViewCell(style: .Default, reuseIdentifier: cellIdentifier)
        
        if let query = query{
            cell.textLabel?.text = "Loading..."
            
        }
        else if (self.statuses == nil){
            cell.textLabel?.text = "Failed to load..."
        }
        else{
            let status:Status = statuses?.objectAtIndex(indexPath.row) as! Status
            cell.textLabel?.text = status.text
        }
        return cell
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
