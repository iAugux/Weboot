//
//  WBBaseViewController.swift
//  iAugus
//
//  Created by Augus on 4/25/15.
//  Copyright (c) 2015 Augus. All rights reserved.
//

import UIKit


class WBBaseViewController: UITableViewController {

    
    var gearRefreshControl: GearRefreshControl!
    var refreshInSeconds: Double!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.gearRefreshManager()
//        self.scrollCoordinatorManager()
        self.automaticPullingDownToRefresh()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func gearRefreshManager(){
        refreshInSeconds = 1.3
        gearRefreshControl = GearRefreshControl(frame: self.view.bounds)
        gearRefreshControl.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        refreshControl = UIRefreshControl()
        refreshControl = gearRefreshControl
    }

    // MARK: - Automatic pulling down to refresh
    func automaticPullingDownToRefresh(){
        
        NSTimer.scheduledTimerWithTimeInterval(0.001, target: self, selector: "automaticContentOffset", userInfo: nil, repeats: false)
        //        NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: "endRefresh", userInfo: nil, repeats: false)
        //        NSTimer.performSelector("endRefresh", withObject: nil, afterDelay: 0.1)
    }
    
    func automaticContentOffset(){
        self.gearRefreshControl.beginRefreshing()
        self.tableView?.setContentOffset(CGPointMake(0, -125), animated: true)
        
    }
    
    
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        self.gearRefreshControl?.scrollViewDidScroll(scrollView)
        self.navigationController?.hidesBarsOnSwipe = true
        self.navigationController?.barHideOnSwipeGestureRecognizer.addTarget(self, action: "hideBarOnSwipe:")
    }
    
    func hideBarOnSwipe(recognizer: UIPanGestureRecognizer) {
        if let bar = self.navigationController?.navigationBar {
            let isHidden = bar.frame.origin.y < 0
            self.tabBarController?.tabBar.hidden = isHidden

        }
    }
    
    
    func refresh(){
        
        self.performSelector("loadStatuses")
        let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64(4 * Double(NSEC_PER_SEC)));
        dispatch_after(popTime, dispatch_get_main_queue()) { () -> Void in
            self.gearRefreshControl?.endRefreshing()
        }
        
    }

}


