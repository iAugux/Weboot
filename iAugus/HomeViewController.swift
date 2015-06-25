//
//  HomeViewController.swift
//  iAugus
//
//  Created by Augus on 4/25/15.
//  Copyright (c) 2015 Augus. All rights reserved.
//

import UIKit
import GearRefreshControl

let kNewWeiboSegue = "newWeiboSegue"
let kWeiboTableViewCell: String = "WeiboTableViewCell"
var publicStatusImageUrl: NSURL?

class HomeViewController: UITableViewController, NewWeiboViewControllerDelegate {
    let mainTabBarController = MainTabBarController()
    var gearRefreshControl: GearRefreshControl!
    var statuses: NSMutableArray?
    var users: NSMutableArray?
    var numberOfRows: NSMutableArray?
    
    var query:WeiboRequestOperation? = WeiboRequestOperation()
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshTableView()
        showCurrentAccountNameOnTimeline()

        numberOfRows = NSMutableArray()
        for var index = 0; index < defaultNumberOfStatusesInTheForstTime; index++ {
            numberOfRows?.addObject(index)
        }
        // part of GearRefreshController
        gearRefreshControl = GearRefreshControl(frame: self.view.bounds)
        gearRefreshControl.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl = gearRefreshControl
        
        
        // register weibo cell
        tableView.rowHeight = 200.0
        tableView.registerNib(UINib(nibName: "WeiboTableViewCell", bundle: nil), forCellReuseIdentifier: "WeiboTableViewCell")
        
        self.loadStatuses()
        self.setupLoadmore()

        
    }
    
    func changeStatusBarColor(){
        //        if bar
        let statusBarView: UIView = UIView(frame: CGRectMake(0, 0, kScreenWidth, 22))
//        statusBarView.backgroundColor = UIColor(red:0.97, green:0.97, blue:0.97, alpha:1)
        statusBarView.backgroundColor = UIColor.redColor()
        //        statusBarView.opaque = true
        //        statusBarView.clearsContextBeforeDrawing = false
        self.view.addSubview(statusBarView)
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
        query = Weibo.getWeibo().queryTimeline(StatusTimelineFriends, count: kNumberOfTimelineRow , completed: ({ statuses, error in
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
        return numberOfRows!.count

    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCellWithIdentifier(kWeiboTableViewCell) as! WeiboTableViewCell
        if statuses != nil{
            var rowHeight:CGFloat = WEIBO_HEADER

            var status = statuses?.objectAtIndex(indexPath.row) as! Status
            // MARK: - original weibo data source
            // set weibo text
            cell.originalWeiboText.text = status.text
            var originalTextSize = ausFrameSizeForText(cell.originalWeiboText, status.text, CGSizeMake(ORIGINAL_TEXT_WIDTH, CGFloat.max))
            rowHeight += originalTextSize.height + 16.0
            
            // set created time
            cell.createdDate.text = status.statusTimeString()
            
            //set weibo source
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
            //            println("numberOfImages = \(numberOfImages)")
            if numberOfImages == 0 {
                cell.imageViewContainer.hidden = true
                cell.imageViewContainerHeight.constant = 0
            }
            else{
                rowHeight += kOriginalWeiboImageWidth + 8.0
                
                cell.imageViewContainer.hidden = false
                cell.imageViewContainerHeight.constant = kOriginalWeiboImageWidth
                // back to default position when imageViewContainer appears again
                cell.imageViewContainer.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
                
                for var i = 0 ; i < numberOfImages ; i++ {
                    var images = [cell.image1, cell.image2, cell.image3, cell.image4, cell.image5, cell.image6, cell.image7, cell.image8, cell.image9]
                    images[i].hidden = false
                    var widthOfImageContainer: CGFloat = (kOriginalWeiboImageWidth + 8) * CGFloat(numberOfImages)
                    if numberOfImages <= 3{
                        cell.imageViewContainerWidth.constant = widthOfImageContainer - 8.0
                        cell.imageViewContainer.scrollEnabled = false
                    }else{
                        cell.imageViewContainerWidth.constant = kScreenWidth - 34.0
                        cell.imageViewContainer.scrollEnabled = true
                    }
                    cell.imageViewContainer.contentSize = CGSize(width: widthOfImageContainer, height: kOriginalWeiboImageWidth)
                    var statusImage: StatusImage! = status.images[i] as? StatusImage
                    let statusImageUrl: NSURL = NSURL(string: statusImage.thumbnailImageUrl)!
                    publicStatusImageUrl = NSURL(string: statusImage.originalImageUrl)
                    //                    println("\(statusImageUrl)")
                    images[i].sd_setImageWithURL(statusImageUrl, placeholderImage: UIImage(named: "image_holder"))
                    
                    let singleTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "singleTapDidTap")
                    singleTap.numberOfTapsRequired = 1
                    images[i].userInteractionEnabled = true
                    images[i].addGestureRecognizer(singleTap)
                    
                    
                }
            }
            
            // MARK: - retweeted Weibo data source
            var retweetedImages = [cell.retweetedImage1, cell.retweetedImage2, cell.retweetedImage3, cell.retweetedImage4, cell.retweetedImage5, cell.retweetedImage6, cell.retweetedImage7, cell.retweetedImage8, cell.retweetedImage9]
            var retweetedViewHeight = CGFloat()
            if let retweetedStatus = status.retweetedStatus{
                // set retweeted weibo text
                if let retweetedWeiboText = status.retweetedStatus?.text{
                    var text = retweetedWeiboText
                    // carefully: when original weibo has been deleted, there is no user !!!  Once you call user, it will crash.
                    if let retweetedWeiboUserName = retweetedStatus.user?.screenName {
                        text = "@\(retweetedWeiboUserName): \(retweetedWeiboText)"
                    }else{
                        text = "\(retweetedWeiboText)"
                    }
               
                    var retweetedLabel = cell.retweetedWeiboText
                    retweetedLabel.text = text
                    var textSize = ausFrameSizeForText(retweetedLabel, text, CGSizeMake(RETWEETED_TEXT_WIDTH, CGFloat.max))
                    
                    
//                    rowHeight += textSize.height + 30.0
                    retweetedViewHeight += textSize.height + 16.0
                }
                
                // set retweeted weibo images
                let numberOfRetweetedImages = retweetedStatus.images.count
                for i in 0..<9 {
                    retweetedImages[i].hidden = true
                }
                if numberOfRetweetedImages == 0 {
                    cell.retweetedImageContainer.hidden = true
                    cell.retweetedImageContainerHeight.constant = 0
                    cell.retweetedContainerHeight.constant = retweetedViewHeight
                }
                else{
//                    rowHeight += kRetweetedWeiboImageWidth + 20.0
                    retweetedViewHeight += kRetweetedWeiboImageWidth + 8.0
                    cell.retweetedContainerHeight.constant = retweetedViewHeight

                    cell.retweetedImageContainer.hidden = false
                    cell.retweetedImageContainerHeight.constant = kRetweetedWeiboImageWidth
                    // back to default position when imageViewContainer appears again
                    cell.retweetedImageContainer.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
                    
                    //                    println("\(cell.retweetedImageContainer.frame.maxY)")
                    for var i = 0 ; i < numberOfRetweetedImages ; i++ {
                        retweetedImages[i].hidden = false
                        var widthOfRetweetedImageContainer: CGFloat = (kRetweetedWeiboImageWidth + 8) * CGFloat(numberOfRetweetedImages)
                        if numberOfRetweetedImages <= 3{
                            cell.retweetedImageContainerWidth.constant = widthOfRetweetedImageContainer - 8.0
                            cell.retweetedImageContainer.scrollEnabled = false
                        }else{
                            cell.retweetedImageContainerWidth.constant = kScreenWidth - 34.0
                            cell.retweetedImageContainer.scrollEnabled = true
                        }
                        cell.retweetedImageContainer.contentSize = CGSize(width: widthOfRetweetedImageContainer, height: kRetweetedWeiboImageWidth)
                        var retweetedStatusImage: StatusImage! = retweetedStatus.images[i] as? StatusImage
                        let retweetedStatusImageUrl: NSURL = NSURL(string: retweetedStatusImage.thumbnailImageUrl)!
                        //                        println("\(retweetedStatusImageUrl)")
                        retweetedImages[i].sd_setImageWithURL(retweetedStatusImageUrl, placeholderImage: UIImage(named: "image_holder"))
                        
                        let singleTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "singleTapDidTap")
                        singleTap.numberOfTapsRequired = 1
                        retweetedImages[i].userInteractionEnabled = true
                        retweetedImages[i].addGestureRecognizer(singleTap)
                        
                        //                        let maxY = retweetedImages.first?.frame.maxY
                        //                        cell.retweetedContainerHeight.constant = maxY!
                    }
                    
                }
                
                //                println("\(cell.retweetedWeiboText.frame.size.height)")
                //                let maxY = retweetedImages.first?.frame.maxY
                //                cell.retweetedContainerHeight.constant = 400
            }else{
                cell.retweetedContainerHeight.constant = 0
                cell.retweetedWeiboText.text = nil
                cell.retweetedImageContainerHeight.constant = 0
                for object in retweetedImages{
                    object.hidden = true
                }
                
            }
//            rowHeight += retweetedViewHeight
            tableView.rowHeight = rowHeight + retweetedViewHeight
//            tableView.rowHeight = 600
            
            
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
    
    
    // MARK: - fake to start refresh
    func refreshTableView(){
        
        NSTimer.scheduledTimerWithTimeInterval(0.001, target: self, selector: "fakeStartRefresh", userInfo: nil, repeats: false)
        //        NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: "endRefresh", userInfo: nil, repeats: false)
        //        NSTimer.performSelector("endRefresh", withObject: nil, afterDelay: 0.1)
    }
    
    func fakeStartRefresh(){
        self.gearRefreshControl.beginRefreshing()
        self.tableView.setContentOffset(CGPointMake(0, -125), animated: true)
        
    }
    

    func setupLoadmore(){
        self.tableView.addFooterWithCallback({
            for var i = 0; i < numberOfLoadmoreStatuses; i++ {
                self.numberOfRows!.addObject(i)
            }
            let delayInSeconds:Int64 = 1000000 * 2
            var popTime:dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW,delayInSeconds)
            dispatch_after(popTime, dispatch_get_main_queue(), {
                self.tableView.reloadData()
                self.tableView.footerEndRefreshing()
//                self.tableView.setFooterHidden(true)
            })
        })
    }

    
}
