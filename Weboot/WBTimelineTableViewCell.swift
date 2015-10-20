//
//  WeiboTableViewCell.swift
//  iAugus
//
//  Created by Augus on 5/11/15.
//  Copyright (c) 2015 Augus. All rights reserved.
//

import UIKit



class WBTimelineTableViewCell: AUSTinderSwipeCell {
    @IBOutlet weak var userImage: UIImageView!{
        didSet{
            userImage.layer.cornerRadius = 20.0
            userImage.clipsToBounds = true
        }
    }
    @IBOutlet weak var screenName: UILabel!{
        didSet{
            screenName.text = nil
        }
    }
    @IBOutlet weak var originalWeiboText: UILabel!{
        didSet{
            originalWeiboText.text = nil
        }
    }
    @IBOutlet weak var createdDate: UILabel!{
        didSet{
            createdDate.text = nil
        }
    }
    @IBOutlet weak var weiboSource: UILabel!{
        didSet{
            weiboSource.text = nil
        }
    }
    @IBOutlet var retweetedWeiboText: UILabel!{
        didSet{
            retweetedWeiboText.text = nil
        }
    }
    
    @IBOutlet var imageViewContainerWidth: NSLayoutConstraint!
    @IBOutlet var imageViewContainer: UIScrollView!
    @IBOutlet var imageViewContainerHeight: NSLayoutConstraint!
    
    @IBOutlet var retweetedContainerHeight: NSLayoutConstraint!{
        didSet{
            retweetedContainerHeight.constant = 0
        }
    }
    @IBOutlet var retweetedImageContainer: UIScrollView!
    @IBOutlet var retweetedImageContainerHeight: NSLayoutConstraint!
    @IBOutlet var retweetedImageContainerWidth: NSLayoutConstraint!
    
    @IBOutlet var commentButton: UIButton!
    @IBOutlet var repostButton: UIButton!
    @IBOutlet var repostsCount: UILabel!{
        didSet{
            repostsCount.text = nil
        }
    }
    @IBOutlet var commentsCount: UILabel!{
        didSet{
            commentsCount.text = nil
        }
    }
    
    //    var images = [UIImageView](count: 9, repeatedValue: UIImageView())
    var images: [UIImageView] = []
    var retweetedImages: [UIImageView] = []
    
    let imageBrowser = HZPhotoBrowser()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.preservesSuperviewLayoutMargins = false
        self.separatorInset = UIEdgeInsetsZero
        self.layoutMargins = UIEdgeInsetsZero
        
        initOriginalWeiboImages()
        initRetweetedWeiboImages()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

    }
    
    @IBAction func commentButton(sender: UIButton) {
        print("comment tapped")
    }
    
    @IBAction func repostButton(sender: UIButton) {
        print("repost tapped")
    }
    
    func initOriginalWeiboImages(){
        imageViewContainer.hidden = true
        imageViewContainerHeight.constant = 0
        // if set scrollsToTop available , it can not be back to top when you tap status bar
        imageViewContainer.scrollsToTop = false
        imageViewContainer.showsHorizontalScrollIndicator = false

        // set image array
        for var index = 0; index < 9; index++ {
            images.append(UIImageView())
            let image_x: CGFloat = (kOriginalWeiboImageWidth + 8) * CGFloat(index)
            images[index].frame = CGRectMake(image_x, 0, kOriginalWeiboImageWidth, kOriginalWeiboImageWidth)
            images[index].contentMode = UIViewContentMode.ScaleAspectFill
            images[index].clipsToBounds = true
            
            
            imageViewContainer.addSubview(images[index])

        }
        
       
      
    }
    
    func initRetweetedWeiboImages(){
        retweetedImageContainer.hidden = true
        retweetedImageContainerHeight.constant = 0
        retweetedImageContainer.scrollsToTop = false
        retweetedImageContainer.showsHorizontalScrollIndicator = false
        
        for var index = 0; index < 9; index++ {
            retweetedImages.append(UIImageView())
            let image_x: CGFloat = (kRetweetedWeiboImageWidth + 8) * CGFloat(index)
            retweetedImages[index].frame = CGRectMake(image_x, 0, kRetweetedWeiboImageWidth, kRetweetedWeiboImageWidth)
            retweetedImages[index].contentMode = UIViewContentMode.ScaleAspectFill
            retweetedImages[index].clipsToBounds = true
            
            retweetedImageContainer.addSubview(retweetedImages[index])
            
        }
        
    }
    
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    
}
