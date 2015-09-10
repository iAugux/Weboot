//
//  HomeViewController.swift
//  iAugus
//
//  Created by Augus on 4/25/15.
//  Copyright (c) 2015 Augus. All rights reserved.
//

import UIKit


class TimelineViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NewWeiboViewControllerDelegate {
    
    struct MainStoryboard{
        struct TableViewCellIdentifiers {
            static let weiboTableViewCell = "weiboTableViewCell"
        }
        struct NibNames {
            static let weiboCellNibName = "WeiboTableViewCell"
        }
    }
    
    @IBOutlet var tableView: UITableView!
    var cellHeight: CGFloat?
    var statuses: NSMutableArray?
    var query: WeiboRequestOperation?

    var refreshControl: UIRefreshControl!
    var numberOfRows: NSMutableArray?
    var refreshInSeconds: Double!
    
    var scrollCoordinator: JDFPeekabooCoordinator!
    var gearRefreshControl: GearRefreshControl!
    
    var timelineModel: TimelineModel!
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        timelineModel = TimelineModel()
        
        automaticPullingDownToRefresh()
        showCurrentAccountNameOnTimeline()
        
        self.loadStatuses()
        self.setupLoadmore()
        
        // register weibo cell
        tableView.registerNib(UINib(nibName: MainStoryboard.NibNames.weiboCellNibName, bundle: nil), forCellReuseIdentifier: MainStoryboard.TableViewCellIdentifiers.weiboTableViewCell)
        tableView.tableFooterView = UIView(frame: CGRectZero)
        // hide separator in the first time, then show the separator after loading data and reloading view
//        tableView.separatorColor = UIColor.clearColor()

        numberOfRows = NSMutableArray()
        for var index = 0; index < defaultNumberOfStatusesInTheFirstTime; index++ {
            numberOfRows?.addObject(0)
        }
        
        gearRefreshManager()
        // hide navigation bar and tab bar on swipe
        scrollCoordinatorManager()
 
    }

    
   
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if !(Weibo.getWeibo().isAuthenticated()){
            showLoginButton()
        }
        else {
            showLogoutButton()
        }
        tableView.reloadData()
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func gearRefreshManager(){
        refreshInSeconds = 1.3
        gearRefreshControl = GearRefreshControl(frame: self.view.bounds)
        gearRefreshControl.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        refreshControl = UIRefreshControl()
        refreshControl = gearRefreshControl
        tableView.addSubview(refreshControl)
    }
    
    func scrollCoordinatorManager(){
        scrollCoordinator = JDFPeekabooCoordinator()
        scrollCoordinator.scrollView = self.tableView
        scrollCoordinator.topView = self.navigationController?.navigationBar
        scrollCoordinator.bottomView = self.tabBarController?.tabBar
        scrollCoordinator.containingView = self.tabBarController?.view
        scrollCoordinator.topViewMinimisedHeight = 21.0
        //        scrollCoordinator.bottomBarDefaultHeight = HEIGHT_OF_TAB_BAR
        

    }
    // MARK: - load data
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
            }
            self.query = nil
            
//            self.tableView.separatorColor = UIColor.lightGrayColor()
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }))
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
            let newWeiboVC = detailVC.viewControllers[0] as! NewWeiboViewController
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
                    NSLog("sign in successful \(account.user.screenName)")
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
    
    
    // MARK: - TableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if query != nil {
            return 0
        }
        if statuses == nil{
            return 0

        }else{
            return numberOfRows!.count
        }
    }
   
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCellWithIdentifier(MainStoryboard.TableViewCellIdentifiers.weiboTableViewCell) as! WeiboTableViewCell
        timelineModel.modelForCell(indexPath, cell: cell, tableView: tableView, vc: self)
        for i in 0..<9{
            let aSelector: Selector = "singleTapDidTap"
            let singleTap = UITapGestureRecognizer(target: self, action: aSelector)
            singleTap.numberOfTapsRequired = 1
            cell.images[i].userInteractionEnabled = true
            cell.images[i].addGestureRecognizer(singleTap)
            
        }
        
        for i in 0..<9{
            let singleTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "singleTapDidTap")
            singleTap.numberOfTapsRequired = 1
            cell.retweetedImages[i].userInteractionEnabled = true
            cell.retweetedImages[i].addGestureRecognizer(singleTap)

        }
        return cell
    }
   
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 200.0
    }
        
    func singleTapDidTap(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("detailImageViewController") as! DetailImageViewController
        vc.modalPresentationStyle = UIModalPresentationStyle.OverFullScreen
        self.presentViewController(vc, animated: true, completion: nil)
        
        print("thumbnail image tapped")
    }
    
    
    
    // MARK: - part of GearRefreshControl
    func refresh(){
        let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64(refreshInSeconds * Double(NSEC_PER_SEC)));
        dispatch_after(popTime, dispatch_get_main_queue()) { () -> Void in
            self.loadStatuses()
//            self.tableView.reloadData()
            self.gearRefreshControl.endRefreshing()
        }
        
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        gearRefreshControl.scrollViewDidScroll(scrollView)
    }
    
    
    // MARK: - Automatic pulling down to refresh
    func automaticPullingDownToRefresh(){
        
        NSTimer.scheduledTimerWithTimeInterval(0.001, target: self, selector: "automaticContentOffset", userInfo: nil, repeats: false)
        //        NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: "endRefresh", userInfo: nil, repeats: false)
        //        NSTimer.performSelector("endRefresh", withObject: nil, afterDelay: 0.1)
    }
    
    func automaticContentOffset(){
        self.gearRefreshControl.beginRefreshing()
        self.tableView.setContentOffset(CGPointMake(0, -125), animated: true)
        
    }
    
    
    func setupLoadmore(){
        self.tableView.addFooterWithCallback({
            for var i = 0; i < numberOfLoadmoreStatuses; i++ {
                self.numberOfRows?.addObject(0)
            }
//                        let delayInSeconds: Double = 0.3
//                        let delta = Int64(Double(NSEC_PER_SEC) * delayInSeconds)
//                        let popTime:dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW,delta)
//                        dispatch_after(popTime, dispatch_get_main_queue(), {
//                            self.tableView.reloadData()
//                            self.tableView.footerEndRefreshing()
//            //                self.tableView.setFooterHidden(true)
//                        })
            self.tableView.reloadData()
            self.tableView.footerEndRefreshing()
        })
    }
    
    
    
}
