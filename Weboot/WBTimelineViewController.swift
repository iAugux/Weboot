//
//  HomeViewController.swift
//  iAugus
//
//  Created by Augus on 4/25/15.
//  Copyright (c) 2015 Augus. All rights reserved.
//

import UIKit


class WBTimelineViewController: WBBaseViewController, WBNewWeiboViewControllerDelegate {
    
    
    var cellHeight: CGFloat?
    var statuses: NSMutableArray?
    var query: WeiboRequestOperation?
    var maxId: Int?
    var numberOfRows: Int?
    var timelineModel: WBTimelineModel!

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.numberOfRows = defaultNumberOfStatusesInTheFirstTime
        self.timelineModel = WBTimelineModel()
        self.showCurrentAccountNameOnTimeline()
        self.loadStatuses()
        self.setupLoadmore()
        
        // register weibo cell
        self.tableView?.registerNib(UINib(nibName: MainStoryboard.NibNames.TimelineTableViewCell, bundle: nil), forCellReuseIdentifier: MainStoryboard.CellIdentifiers.timelineTableViewCell)
        self.tableView?.tableFooterView = UIView(frame: CGRectZero)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if !(Weibo.getWeibo().isAuthenticated()){
            showLoginButton()
        }
        else {
            showLogoutButton()
        }
        self.tableView?.reloadData()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - set navigationItem' title to name of currentAccount
    func showCurrentAccountNameOnTimeline(){
        if Weibo.getWeibo().isAuthenticated(){
            let nameOfCurrentAccount = Weibo.getWeibo().currentAccount().user.name
            self.navigationItem.title = nameOfCurrentAccount
        }
    }
    
    
    // MARK: - Post new weibo
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == kNewWeiboSegue{
            let detailVC = segue.destinationViewController as! UINavigationController
            let newWeiboVC = detailVC.viewControllers[0] as! WBNewWeiboViewController
            newWeiboVC.delegate = self
        }
    }
    
    func loadDataAfterPostNewWeibo() {
        self.loadStatuses()
    }
    
    // MARK: - login or logout
    
    func showLoginButton(){
        let loginButton = UIBarButtonItem(title: "Login", style: UIBarButtonItemStyle.Plain, target: self, action: "loginWeibo")
        self.navigationItem.leftBarButtonItem = loginButton
    }
    
    func showLogoutButton(){
        let logoutButton = UIBarButtonItem(title: "Logout", style: .Plain, target: self, action: "logoutWeibo")
        self.navigationItem.leftBarButtonItem = logoutButton
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func loginWeibo(){
        
        if !(Weibo.getWeibo().isAuthenticated()){
            print("not authenticated! and authenticating...")
            Weibo.getWeibo().authorizeWithCompleted({ account, error in
                if error == nil{
                    NSLog("sign in successfully \(account.user.screenName)")
                    self.loadStatuses()
                    self.showCurrentAccountNameOnTimeline()
                    self.automaticPullingDownToRefresh()
                    //                    self.tableView.reloadData()
                }
                    
                else{
                    NSLog("failed to sign in \(error)")
                }
            })
        }
        else{
            print("has been already authenticated!")
        }
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
    
    
    func setupLoadmore(){
        print("start to load more")
        self.tableView?.addFooterWithCallback({
            if self.maxId < Int(kNumberOfTimelineRow) {
                self.loadMoreStatuses(Int32(numberOfLoadmoreStatuses))
                
            } else {
                UIApplication.topMostViewController()?.view.makeToast(message: "F**k Sina! No more data allowed.", duration: 0.7, position: HRToastPositionCenter)
            }
            
            self.tableView?.footerEndRefreshing()
        })
    }
    
    
}

// MARK: - load data
extension WBTimelineViewController {
    func loadStatuses(){
        query = WeiboRequestOperation()
        statuses = nil
        if query != nil {
            query!.cancel()
        }
        query = Weibo.getWeibo().queryTimeline(StatusTimelineFriends, count: kNumberOfTimelineRow , completed: ({ statuses, error in
            if error != nil{
                self.statuses = nil
                NSLog("error: \(error) , please login...")
            }
            else{
                self.statuses = statuses
                self.maxId = defaultNumberOfStatusesInTheFirstTime
            }
            self.query = nil
            
            self.tableView?.reloadData()
            self.refreshControl!.endRefreshing()
        }))
    }
    
    func loadMoreStatuses(count: Int32){
        query = WeiboRequestOperation()
        if query != nil {
            query?.cancel()
        }
        
        query = Weibo.getWeibo().queryTimeline(StatusTimelineFriends, sinceId: Int64(statuses!.count), count: count, completed: { (statuses , error ) -> Void in
            print("loading more")
            if error != nil{
                self.statuses = nil
                NSLog("error: \(error) , please login...")
            }
            else{
                self.statuses?.addObjectsFromArray(statuses as [AnyObject])
                self.numberOfRows? += statuses.count
                self.maxId! += numberOfLoadmoreStatuses
            }
            self.query = nil
            self.tableView.reloadData()
            self.refreshControl!.endRefreshing()
        })
    }
    
}

// MARK: - TableViewDataSource
extension WBTimelineViewController {
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if query != nil {
            return 0
        }
        if statuses == nil{
            return 0
            
        }else{
            return numberOfRows!
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCellWithIdentifier(MainStoryboard.CellIdentifiers.timelineTableViewCell) as? WBTimelineTableViewCell {
            timelineModel.modelForCell(indexPath, cell: cell, tableView: tableView, vc: self)



            for i in 0..<9{
                let aSelector: Selector = "singleTapDidTap"
                let singleTap = UITapGestureRecognizer(target: self, action: aSelector)
                singleTap.numberOfTapsRequired = 1
                cell.images[i].userInteractionEnabled = true
                cell.images[i].addGestureRecognizer(singleTap)
                
              

                
            }
//
//            for i in 0..<9{
//                let singleTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "singleTapDidTap")
//                singleTap.numberOfTapsRequired = 1
//                cell.retweetedImages[i].userInteractionEnabled = true
//                cell.retweetedImages[i].addGestureRecognizer(singleTap)
//                
//            }

            return cell
        }
        
        return UITableViewCell()
    }
    
    func singleTapDidTap(){
        //        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //        let vc = storyboard.instantiateViewControllerWithIdentifier("detailImageViewController") as! DetailImageViewController
        //        vc.modalPresentationStyle = UIModalPresentationStyle.OverFullScreen
        //        self.presentViewController(vc, animated: true, completion: nil)
        //
        //        print("thumbnail image tapped")
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 200.0
    }
    
}
