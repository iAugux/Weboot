//
//  WeiboTableViewCell.swift
//  iAugus
//
//  Created by Augus on 5/11/15.
//  Copyright (c) 2015 Augus. All rights reserved.
//

import UIKit



class WeiboTableViewCell: UITableViewCell {
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var screenName: UILabel!
//    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var originalWeiboText: UILabel!
    @IBOutlet weak var createdDate: UILabel!
    @IBOutlet weak var weiboSource: UILabel!
    @IBOutlet var imageViewContainerWidth: NSLayoutConstraint!
    @IBOutlet var imageViewContainer: UIScrollView!
    @IBOutlet var imageViewContainerHeight: NSLayoutConstraint!
    
    @IBOutlet var retweetedContainerHeight: NSLayoutConstraint!
    @IBOutlet var retweetedWeiboText: UILabel!
    @IBOutlet var retweetedImageContainer: UIScrollView!
    @IBOutlet var retweetedImageContainerHeight: NSLayoutConstraint!
    @IBOutlet var retweetedImageContainerWidth: NSLayoutConstraint!
    
    var image1: UIImageView = UIImageView()
    var image2: UIImageView = UIImageView()
    var image3: UIImageView = UIImageView()
    var image4: UIImageView = UIImageView()
    var image5: UIImageView = UIImageView()
    var image6: UIImageView = UIImageView()
    var image7: UIImageView = UIImageView()
    var image8: UIImageView = UIImageView()
    var image9: UIImageView = UIImageView()

    var retweetedImage1: UIImageView = UIImageView()
    var retweetedImage2: UIImageView = UIImageView()
    var retweetedImage3: UIImageView = UIImageView()
    var retweetedImage4: UIImageView = UIImageView()
    var retweetedImage5: UIImageView = UIImageView()
    var retweetedImage6: UIImageView = UIImageView()
    var retweetedImage7: UIImageView = UIImageView()
    var retweetedImage8: UIImageView = UIImageView()
    var retweetedImage9: UIImageView = UIImageView()


    override func awakeFromNib() {
        super.awakeFromNib()
        initControllers()
     
//        originalWeiboText.adjustsFontSizeToFitWidth = false
//        retweetedWeiboText.adjustsFontSizeToFitWidth = false
    }
   
    func initControllers(){
//        userImage.image = nil
        screenName.text = nil
        originalWeiboText.text = nil
        createdDate.text = nil
        weiboSource.text = nil
//        originalWeiboImages.image = nil
    
        self.preservesSuperviewLayoutMargins = false
        self.separatorInset = UIEdgeInsetsZero
        self.layoutMargins = UIEdgeInsetsZero
        
        userImage.layer.cornerRadius = 20.0
        userImage.clipsToBounds = true
        
        
        initOriginalWeiboImages()
        retweetedContainerHeight.constant = 0
        retweetedWeiboText.text = nil
        
        initRetweetedWeiboImages()
        
    }
    
    func initOriginalWeiboImages(){
        imageViewContainer.hidden = true
        imageViewContainerHeight.constant = 0
        // if set scrollsToTop available , it can not be back to top when you tap status bar
        imageViewContainer.scrollsToTop = false
        imageViewContainer.showsHorizontalScrollIndicator = false

        // set image array
        var images = [image1, image2, image3, image4, image5, image6, image7, image8, image9]
        for var index = 0; index < 9; index++ {
            var image_x: CGFloat = (kOriginalWeiboImageWidth + 8) * CGFloat(index)
            images[index].frame = CGRectMake(image_x, 0, kOriginalWeiboImageWidth, kOriginalWeiboImageWidth)
            images[index].contentMode = UIViewContentMode.ScaleAspectFill
            images[index].clipsToBounds = true
            var imageArray: NSMutableArray?
            imageArray?.addObject(images[index])
            
            imageViewContainer.addSubview(images[index])
            
        }
    }
   
    func initRetweetedWeiboImages(){
        retweetedImageContainer.hidden = true
        retweetedImageContainerHeight.constant = 0
        retweetedImageContainer.scrollsToTop = false
        retweetedImageContainer.showsHorizontalScrollIndicator = false
        var retweetedImages = [retweetedImage1, retweetedImage2, retweetedImage3, retweetedImage4, retweetedImage5, retweetedImage6, retweetedImage7, retweetedImage8, retweetedImage9]
        for var index = 0; index < 9; index++ {
            var image_x: CGFloat = (kRetweetedWeiboImageWidth + 8) * CGFloat(index)
            retweetedImages[index].frame = CGRectMake(image_x, 0, kRetweetedWeiboImageWidth, kRetweetedWeiboImageWidth)
            retweetedImages[index].contentMode = UIViewContentMode.ScaleAspectFill
            retweetedImages[index].clipsToBounds = true
            var imageArray: NSMutableArray?
            imageArray?.addObject(retweetedImages[index])
            
            retweetedImageContainer.addSubview(retweetedImages[index])
            
        }

    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
   
}
