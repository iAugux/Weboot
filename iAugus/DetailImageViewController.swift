//
//  DetailImageViewController.swift
//  iAugus
//
//  Created by Augus on 5/22/15.
//  Copyright (c) 2015 Augus. All rights reserved.
//

import UIKit


class DetailImageViewController: UIViewController {
    let originalWeiboCell = WeiboTableViewCell()
    @IBOutlet var detailImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        detailImageView.backgroundColor = UIColor(white: 0.500, alpha: 0.490)
//        detailImageView.backgroundColor = UIColor.blueColor()
//        detailImageView.backgroundColor?.colorWithAlphaComponent(0.5)
//        detailImageView?.image = UIImage(named: "image_holder")
//        detailImageView.contentMode = UIViewContentMode.Top
        detailImageView.clipsToBounds = true
        showDetailImage()
        
    }
    
    
    func showDetailImage(){
        let imageSingleTapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "singleTap")
        imageSingleTapGesture.numberOfTapsRequired = 1
        detailImageView?.userInteractionEnabled = true
        detailImageView?.addGestureRecognizer(imageSingleTapGesture)
        
    }
    
    func singleTap(){
        println("detail image view tapped")
        self.dismissViewControllerAnimated(true, completion: nil)
        tabBarController?.tabBar.becomeFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
}
