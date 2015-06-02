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
    @IBOutlet var imageViewContainer: UIScrollView!

    
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
        self.preservesSuperviewLayoutMargins = false
        self.separatorInset = UIEdgeInsetsZero
        self.layoutMargins = UIEdgeInsetsZero
        
        // Initialization code
        initControllers()
        userImage.layer.cornerRadius = 20.0
        userImage.clipsToBounds = true
        imageViewContainer!.hidden = true
        imageViewContainer.scrollsToTop = false
        
        imageViewContainer.showsHorizontalScrollIndicator = false
        // set image array
        var images = [image1, image2, image3, image4, image5, image6, image7, image8, image9]
        for var index = 0; index < 9; index++ {
            var image_x: CGFloat = 25.0 + (originalWeiboImageWidth + 8) * CGFloat(index)
            images[index].frame = CGRectMake(image_x, 0, originalWeiboImageWidth, originalWeiboImageWidth)
            images[index].contentMode = UIViewContentMode.ScaleAspectFill
            images[index].clipsToBounds = true
            var imageArray: NSMutableArray?
            imageArray?.addObject(images[index])

            imageViewContainer.addSubview(images[index])

        }
        
//        var retweetedImages = [image1, image2, image3, image4, image5, image6, image7, image8, image9]
//        for var i = 0; i < 9; i++ {
//            var image_x: CGFloat = 25.0 + (retweetedWeiboImageWidth + 8) * CGFloat(i)
//            retweetedImages[i].frame = CGRectMake(image_x, 0, retweetedWeiboImageWidth, retweetedWeiboImageWidth)
//            retweetedImages[i].contentMode = UIViewContentMode.ScaleAspectFill
//            retweetedImages[i].clipsToBounds = true
//            var imageArray: NSMutableArray?
//            imageArray?.addObject(retweetedImages[i])
//            
//            retweetedImageViewContainer.addSubview(retweetedImages[i])
//            
//        }
        
      
    }
    
   
    func initControllers(){
//        userImage.image = nil
        screenName.text = nil
        originalWeiboText.text = nil
        createdDate.text = nil
        weiboSource.text = nil
//        imageViewContainer.hidden = true
       
        
    }
   
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
   
}
