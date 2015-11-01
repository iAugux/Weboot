//
//  WeiboTableViewswift
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
    
    @IBOutlet var imageViewContainer: UIScrollView!
    @IBOutlet var imageViewContainerWidth: NSLayoutConstraint!
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
    
    var imagesBrowser: [SKPhoto] = []
    
    var cellHeight: CGFloat!
    
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
            let image_x: CGFloat = IMAGE_LEADING_SPACE + (kOriginalWeiboImageWidth + 8) * CGFloat(index)
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
            let image_x: CGFloat = IMAGE_LEADING_SPACE + (kRetweetedWeiboImageWidth + 8) * CGFloat(index)
            retweetedImages[index].frame = CGRectMake(image_x, 0, kRetweetedWeiboImageWidth, kRetweetedWeiboImageWidth)
            retweetedImages[index].contentMode = UIViewContentMode.ScaleAspectFill
            retweetedImages[index].clipsToBounds = true
            
            retweetedImageContainer.addSubview(retweetedImages[index])
            
        }
        
    }
    
    func loadDataToCell(status: Status) {
        var totalHeight:CGFloat = WEIBO_HEADER_HEIGHT
        
        // MARK: - original weibo data source
        // set weibo text
        originalWeiboText.text = status.text
        let originalTextSize = originalWeiboText.ausGetLabelSize()
        
        totalHeight += originalTextSize.height + 16.0
        
        createdDate?.text = status.statusTimeString()
        weiboSource?.text = status.source
        screenName?.text = status.user.screenName
        repostsCount?.text = "\(status.repostsCount)"
        commentsCount?.text = "\(status.commentsCount)"
        
        // set user image
        if let userImageUrl: NSURL = NSURL(string: status.user.profileImageUrl){
            userImage.kf_setImageWithURL(userImageUrl, placeholderImage: UIImage(named: "profile_image_placeholder"))
        }
        
        // set original weibo images
        let numberOfImages = status.images.count
        for i in 0..<9 {
            images[i].hidden = true
        }
        if numberOfImages == 0 {
            imageViewContainer.hidden = true
            imageViewContainerHeight.constant = 0
        }
        else{
            totalHeight += kOriginalWeiboImageWidth + 8.0
            
            imageViewContainer.hidden = false
            imageViewContainerHeight.constant = kOriginalWeiboImageWidth
            // back to default position when imageViewContainer appears again
            imageViewContainer.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
            
            let widthOfImageContainer: CGFloat = (kOriginalWeiboImageWidth + 8) * CGFloat(numberOfImages) + IMAGE_LEADING_SPACE
            var imageOfBrowser: SKPhoto
            self.imagesBrowser.removeAll()
            for var i = 0 ; i < numberOfImages ; i++ {
                images[i].hidden = false
                images[i].tag = i
                if widthOfImageContainer < UIScreen.screenWidth() {
                    imageViewContainerWidth.constant = widthOfImageContainer - 8.0
                    imageViewContainer.scrollEnabled = false
                }else{
                    imageViewContainerWidth.constant = UIScreen.screenWidth()
                    imageViewContainer.scrollEnabled = true
                }
                imageViewContainer.contentSize = CGSizeMake(widthOfImageContainer , kOriginalWeiboImageWidth)
                let statusImage = status.images[i] as! StatusImage
                let statusImageUrl = NSURL(string: statusImage.thumbnailImageUrl)
                images[i].kf_setImageWithURL(statusImageUrl!, placeholderImage: UIImage(named: "image_holder"))

                let recognizer = UITapGestureRecognizer(target: self, action: "imageDidTap:")
                images[i].addGestureRecognizer(recognizer)
                images[i].userInteractionEnabled = true
                
                imageOfBrowser = SKPhoto.photoWithImageURL(statusImage.originalImageUrl)
                imageOfBrowser.shouldCachePhotoURLImage = true
                self.imagesBrowser.append(imageOfBrowser)
                
                
            }
            
        }
        
        
        
        // MARK: - retweeted Weibo data source
        var retweetedViewHeight: CGFloat = 0.0
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
                
                let retweetedLabel = self.retweetedWeiboText
                retweetedLabel.text = text
                let textSize = retweetedLabel.ausGetLabelSize()
                retweetedViewHeight += textSize.height + 16.0
            }
            
            // set retweeted weibo images
            let numberOfRetweetedImages = retweetedStatus.images.count
            for i in 0..<9 {
                retweetedImages[i].hidden = true
            }
            if numberOfRetweetedImages == 0 {
                retweetedImageContainer.hidden = true
                retweetedImageContainerHeight.constant = 0
                retweetedContainerHeight.constant = retweetedViewHeight
            }
            else{
                retweetedViewHeight += kRetweetedWeiboImageWidth + 8.0
                retweetedContainerHeight.constant = retweetedViewHeight
                
                retweetedImageContainer.hidden = false
                retweetedImageContainerHeight.constant = kRetweetedWeiboImageWidth
                // back to default position when imageViewContainer appears again
                retweetedImageContainer.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
                
                let widthOfRetweetedImageContainer: CGFloat = (kRetweetedWeiboImageWidth + 8) * CGFloat(numberOfRetweetedImages) + IMAGE_LEADING_SPACE
                var imageOfBrowser: SKPhoto
                self.imagesBrowser.removeAll()
                for var i = 0 ; i < numberOfRetweetedImages ; i++ {
                    retweetedImages[i].hidden = false
                    retweetedImages[i].tag = i
                    if widthOfRetweetedImageContainer < UIScreen.screenWidth() {
                        retweetedImageContainerWidth.constant = widthOfRetweetedImageContainer - 8.0
                        retweetedImageContainer.scrollEnabled = false
                    }else{
                        retweetedImageContainerWidth.constant = UIScreen.screenWidth()
                        retweetedImageContainer.scrollEnabled = true
                    }
                    retweetedImageContainer.contentSize = CGSizeMake(widthOfRetweetedImageContainer, kRetweetedWeiboImageWidth)
                    let retweetedStatusImage = retweetedStatus.images[i] as! StatusImage
                    let retweetedStatusImageUrl = NSURL(string: retweetedStatusImage.thumbnailImageUrl)
                    
                    retweetedImages[i].kf_setImageWithURL(retweetedStatusImageUrl!, placeholderImage: UIImage(named: "image_holder"))
                    
                    let recognizer = UITapGestureRecognizer(target: self, action: "imageDidTap:")
                    retweetedImages[i].addGestureRecognizer(recognizer)
                    retweetedImages[i].userInteractionEnabled = true
                    
                    imageOfBrowser = SKPhoto.photoWithImageURL(retweetedStatusImage.originalImageUrl)
                    imageOfBrowser.shouldCachePhotoURLImage = true
                    self.imagesBrowser.append(imageOfBrowser)

                }
                
            }
            
        }
        else{
            retweetedViewHeight = 0.0
            retweetedContainerHeight.constant = 0
            retweetedWeiboText.text = nil
            retweetedImageContainerHeight.constant = 0
            for object in retweetedImages{
                object.hidden = true
            }
        }
        cellHeight = totalHeight + retweetedViewHeight + 21.0 + 8.0
    }

    func imageDidTap(sender: UITapGestureRecognizer) {
        print("image did tap")

        let browser = SKPhotoBrowser(photos: imagesBrowser)
        browser.initializePageIndex(sender.view!.tag)
        UIApplication.topMostViewController()?.presentViewController(browser, animated: true, completion: nil)
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }


}
