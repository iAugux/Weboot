//
//  NewWeiboViewController.swift
//  iAugus
//
//  Created by Augus on 5/15/15.
//  Copyright (c) 2015 Augus. All rights reserved.
//

import UIKit

protocol NewWeiboViewControllerDelegate{
    func loadDataAfterPostNewWeibo()
}

class NewWeiboViewController: UIViewController{
    var query: WeiboRequestOperation?

    @IBOutlet weak var newWeiboTextField: UITextView!
    
    var delegate: NewWeiboViewControllerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newWeiboTextField.becomeFirstResponder()
    }

    @IBAction func newWeiboCanceled(sender: AnyObject) {
        newWeiboTextField.resignFirstResponder()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func postNewWeiboButton(sender: AnyObject) {
        postWeibo()
    }
    func postWeibo(){
        let status: NSString = newWeiboTextField.text
        let picData: NSData = NSData()
        query = Weibo.getWeibo().newStatus(status as String, pic: picData, completed: { data, error in
            if error != nil{
                print(error)
            }
            else{
                self.delegate.loadDataAfterPostNewWeibo()
                self.newWeiboTextField.resignFirstResponder()
                self.dismissViewControllerAnimated(true, completion: nil)
            }
            
        })
    }
    
    // MARK: - close keyboard after touching out of textfield
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        newWeiboTextField.resignFirstResponder()
    }
    
    
    
    // MARK: - memory manager
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
