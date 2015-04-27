//
//  AtNavigationController.swift
//  iAugus
//
//  Created by Augus on 4/26/15.
//  Copyright (c) 2015 Augus. All rights reserved.
//

import UIKit

class AtNavigationController: BaseNavigationController {

    @IBOutlet weak var atTabBarItem: UITabBarItem!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    override func viewDidAppear(animated: Bool) {
        atTabBarItem.title = "✯"
    }
    override func viewWillDisappear(animated: Bool) {
        atTabBarItem.title = ""
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
