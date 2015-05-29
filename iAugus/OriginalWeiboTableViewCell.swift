//
//  OriginalWeiboTableViewCell.swift
//  iAugus
//
//  Created by Augus on 5/11/15.
//  Copyright (c) 2015 Augus. All rights reserved.
//

import UIKit



class OriginalWeiboTableViewCell: UITableViewCell, ASMediasFocusDelegate {
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var screenName: UILabel!
//    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var originalWeiboText: UILabel!
    @IBOutlet weak var createdDate: UILabel!
    @IBOutlet weak var weiboSource: UILabel!
    @IBOutlet var imageViewContainer: UIScrollView!

    let mediaFocusManager = ASMediaFocusManager()
    let homeViewController = HomeViewController()
    
    var image1: UIImageView = UIImageView()
    var image2: UIImageView = UIImageView()
    var image3: UIImageView = UIImageView()
    var image4: UIImageView = UIImageView()
    var image5: UIImageView = UIImageView()
    var image6: UIImageView = UIImageView()
    var image7: UIImageView = UIImageView()
    var image8: UIImageView = UIImageView()
    var image9: UIImageView = UIImageView()

    

    override func awakeFromNib() {
        super.awakeFromNib()
        
//        self.preservesSuperviewLayoutMargins = false
        self.separatorInset = UIEdgeInsetsZero
        // Initialization code
        userImage.layer.cornerRadius = 20.0
        userImage.clipsToBounds = true
        initControllers()
        imageViewContainer!.hidden = true
        imageViewContainer.scrollsToTop = false
        imageViewContainer.showsHorizontalScrollIndicator = false
        // set image array
        var images = [image1, image2, image3, image4, image5, image6, image7, image8, image9]
        for var index = 0; index < 9; index++ {
            var image_x: CGFloat = 20.0 + (originalWeiboImageWidth + 8) * CGFloat(index)
            images[index].frame = CGRectMake(image_x, 0, originalWeiboImageWidth, originalWeiboImageWidth)
            images[index].contentMode = UIViewContentMode.ScaleAspectFill
            images[index].clipsToBounds = true
            var imageArray: NSMutableArray?
            imageArray?.addObject(images[index])

            imageViewContainer.addSubview(images[index])

        }
        
        
        self.mediaFocusManager.delegate = self
        self.mediaFocusManager.installOnView(imageView)
        
    }
    
   
    func initControllers(){
//        userImage.image = nil
        screenName.text = nil
        originalWeiboText.text = nil
        createdDate.text = nil
        weiboSource.text = nil
//        originalWeiboImages.image = nil
    }
   
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - ASMediaFocusManagerDelegate
    func parentViewControllerForMediaFocusManager(mediaFocusManager: ASMediaFocusManager!) -> UIViewController! {
        return homeViewController
    }
    func mediaFocusManager(mediaFocusManager: ASMediaFocusManager!, mediaURLForView view: UIView!) -> NSURL! {
        let url = NSURL(string: "")
        return url
    }
    func mediaFocusManager(mediaFocusManager: ASMediaFocusManager!, titleForView view: UIView!) -> String! {
        let st = ""
        return st
    }

}
