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

let kNewWeiboSegue = "newWeiboSegue"
let kWeiboTableViewCell: String = "WeiboTableViewCell"

class HomeViewController: UITableViewController, NewWeiboViewControllerDelegate {
    let mainTabBarController = MainTabBarController()
    var gearRefreshControl: GearRefreshControl!

    var statuses: NSMutableArray?
    var users: NSMutableArray?
    
    var query:WeiboRequestOperation? = WeiboRequestOperation()
    //    var storyboard = UIStoryboard(name: "Main", bundle: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        refreshTableView()
        
        self.loadStatuses()
        showCurrentAccountNameOnTimeline()
        // part of GearRefreshController
        gearRefreshControl = GearRefreshControl(frame: self.view.bounds)
        gearRefreshControl.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl = gearRefreshControl
        
        // register weibo cell
        tableView.rowHeight = 600.0
        tableView.registerNib(UINib(nibName: "WeiboTableViewCell", bundle: nil), forCellReuseIdentifier: "WeiboTableViewCell")
        


    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
    
    // set navigationItem' title to name of currentAccount
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
            var newWeiboVC = detailVC.viewControllers[0] as! NewWeiboViewController
            newWeiboVC.delegate = self
        }
    }
    
    func postNewWeibo(controller: NewWeiboViewController) {
        loadStatuses()
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
            tableView.reloadData()
        }
        else{
            println("has already been authenticated!")
            self.loadStatuses()
            tableView.reloadData()
        }
        self.loadStatuses()
        tableView.reloadData()
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
        let cell = tableView.dequeueReusableCellWithIdentifier(kWeiboTableViewCell) as! WeiboTableViewCell
//        cell.preservesSuperviewLayoutMargins = false
//        cell.separatorInset = UIEdgeInsetsZero

        if statuses != nil{
            var status = statuses?.objectAtIndex(indexPath.row) as! Status
            
            // MARK: - original weibo data source
            
            // set weibo text
            cell.originalWeiboText.text = status.text
            
            // set created time
            cell.createdDate.text = status.statusTimeString()
            
            // set weibo source
            cell.weiboSource.text = status.source
            
            // set ScreenName
            cell.screenName.text = status.user.screenName
            
            // set user image
            if let userImageUrl: NSURL = NSURL(string: status.user.profileImageUrl){
                cell.userImage.sd_setImageWithURL(userImageUrl, placeholderImage: UIImage(named: "profile_image_placeholder"))
            }
            
            // set original weibo images
            var numberOfImages = status.images.count
            for i in 0..<9 {
                var images = [cell.image1, cell.image2, cell.image3, cell.image4, cell.image5, cell.image6, cell.image7, cell.image8, cell.image9]
                images[i].hidden = true
            }
            println("numberOfImages = \(numberOfImages)")
            if numberOfImages == 0 {
                cell.imageViewContainer.hidden = true
            }
            else{
                cell.imageViewContainer.hidden = false
//                cell.originalWeiboImageHeight.constant = originalWeiboImageWidth
//                cell.imageViewContainer.contentSize.height = originalWeiboImageWidth
                // back to default position when imageViewContainer appears again
                cell.imageViewContainer.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
                
                for var i = 0 ; i < numberOfImages ; i++ {
                    var images = [cell.image1, cell.image2, cell.image3, cell.image4, cell.image5, cell.image6, cell.image7, cell.image8, cell.image9]
                    images[i].hidden = false
                    var widthOfImageContainer: CGFloat = 25.0 + (originalWeiboImageWidth + 8) * CGFloat(numberOfImages)
                    cell.imageViewContainer.contentSize = CGSize(width: widthOfImageContainer, height: 125.0)
                    
                    var statusImage: StatusImage! = status.images[numberOfImages - i - 1] as? StatusImage
                    let statusImageUrl: NSURL = NSURL(string: statusImage.middleImageUrl)!
                    
                    images[i].sd_setImageWithURL(statusImageUrl, placeholderImage: UIImage(named: "image_holder"))
//                    images[i].contentMode = UIViewContentMode.ScaleToFill
                    
                    let singleTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "singleTapDidTap")
                    singleTap.numberOfTapsRequired = 1
                    images[i].userInteractionEnabled = true
                    images[i].addGestureRecognizer(singleTap)
                    
                }
            }
            
            
            // MARK: - retweeted weibo data source
            
            // set retweeted weibo text
            if let retweetedWeiboText = status.retweetedStatus?.text {
//                cell.retweetedViewContainer.hidden = false
//                cell.retweetedWeiboText.text = retweetedWeiboText
            }
            // set retweeted weibo image
            
            
        }
        
        
        return cell
    }
    func singleTapDidTap(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: DetailImageViewController = storyboard.instantiateViewControllerWithIdentifier("detailImageViewController") as! DetailImageViewController
        vc.modalPresentationStyle = UIModalPresentationStyle.OverFullScreen
        self.presentViewController(vc, animated: true, completion: nil)
        
        println("thumbnail image tapped")
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
    
    
    // fake to start refresh
    func refreshTableView(){
        
        NSTimer.scheduledTimerWithTimeInterval(0.001, target: self, selector: "fakeStartRefresh", userInfo: nil, repeats: false)
        //        NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: "endRefresh", userInfo: nil, repeats: false)
        //        NSTimer.performSelector("endRefresh", withObject: nil, afterDelay: 0.1)
    }
    
    func fakeStartRefresh(){
        self.gearRefreshControl.beginRefreshing()
        self.tableView.setContentOffset(CGPointMake(0, -125), animated: true)
        
    }
    
    
}
