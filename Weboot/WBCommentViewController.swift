//
//  WBCommentViewController.swift
//  iAugus
//
//  Created by Augus on 4/25/15.
//  Copyright (c) 2015 Augus. All rights reserved.
//

import UIKit

class WBCommentViewController: WBBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerNib(UINib(nibName: kWeiboTableViewCell, bundle: nil), forHeaderFooterViewReuseIdentifier: kWeiboTableViewCell)
        tableView.tableFooterView = UIView(frame: CGRectZero)

        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(kWeiboTableViewCell) as! WBTimelineTableViewCell
        return cell
        
    }
}
