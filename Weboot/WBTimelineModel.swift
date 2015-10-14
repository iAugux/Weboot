//
//  WBTimelineModel.swift
//  iAugus
//
//  Created by Augus on 7/12/15.
//  Copyright © 2015 Augus. All rights reserved.
//

import Foundation
import Kingfisher


class WBTimelineModel: NSObject {
    
    func modelForCell(indexPath: NSIndexPath, cell: WBTimelineTableViewCell, tableView: UITableView, vc: WBTimelineViewController) {
        let statuses = vc.statuses
        if statuses != nil{
            var rowHeight:CGFloat = WEIBO_HEADER_HEIGHT
            
            let status = statuses?.objectAtIndex(indexPath.row) as! Status
            // MARK: - original weibo data source
            // set weibo text
            cell.originalWeiboText.text = status.text
            let originalTextSize = ausFrameSizeForText(status.text , font: UIFont.systemFontOfSize(ORIGINAL_FONT_SIZE), maximumSize: CGSizeMake(ORIGINAL_TEXT_WIDTH, CGFloat.max))
            rowHeight += originalTextSize.height + 16.0
            
            cell.createdDate?.text = status.statusTimeString()
            cell.weiboSource?.text = status.source
            cell.screenName?.text = status.user.screenName
            cell.repostsCount?.text = "\(status.repostsCount)"
            cell.commentsCount?.text = "\(status.commentsCount)"
            
            // set user image
            if let userImageUrl: NSURL = NSURL(string: status.user.profileImageUrl){
                cell.userImage.kf_setImageWithURL(userImageUrl, placeholderImage: UIImage(named: "profile_image_placeholder"))
            }
            
            // set original weibo images
            let numberOfImages = status.images.count
            for i in 0..<9 {
                cell.images[i].hidden = true
            }
            if numberOfImages == 0 {
                cell.imageViewContainer.hidden = true
                cell.imageViewContainerHeight.constant = 0
            }
            else{
                rowHeight += kOriginalWeiboImageWidth + 8.0
                
                cell.imageViewContainer.hidden = false
                cell.imageViewContainerHeight.constant = kOriginalWeiboImageWidth
                // back to default position when imageViewContainer appears again
                cell.imageViewContainer.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
                
                for var i = 0 ; i < numberOfImages ; i++ {
                    cell.images[i].hidden = false
                    let widthOfImageContainer: CGFloat = (kOriginalWeiboImageWidth + 8) * CGFloat(numberOfImages)
                    if numberOfImages <= 3{
                        cell.imageViewContainerWidth.constant = widthOfImageContainer - 8.0
                        cell.imageViewContainer.scrollEnabled = false
                    }else{
                        cell.imageViewContainerWidth.constant = kScreenWidth - 34.0
                        cell.imageViewContainer.scrollEnabled = true
                    }
                    cell.imageViewContainer.contentSize = CGSize(width: widthOfImageContainer, height: kOriginalWeiboImageWidth)
                    let statusImage = status.images[i] as! StatusImage
                    let statusImageUrl = NSURL(string: statusImage.thumbnailImageUrl)

                    cell.images[i].kf_setImageWithURL(statusImageUrl!, placeholderImage: UIImage(named: "image_holder"))
                    
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
                    
                    let retweetedLabel = cell.retweetedWeiboText
                    retweetedLabel.text = text
                    let textSize = ausFrameSizeForText(text , font: UIFont.systemFontOfSize(RETWEETED_FONT_SIZE), maximumSize: CGSizeMake(RETWEETED_TEXT_WIDTH, CGFloat.max))
                    retweetedViewHeight += textSize.height + 16.0
                }
                
                // set retweeted weibo images
                let numberOfRetweetedImages = retweetedStatus.images.count
                for i in 0..<9 {
                    cell.retweetedImages[i].hidden = true
                }
                if numberOfRetweetedImages == 0 {
                    cell.retweetedImageContainer.hidden = true
                    cell.retweetedImageContainerHeight.constant = 0
                    cell.retweetedContainerHeight.constant = retweetedViewHeight
                }
                else{
                    retweetedViewHeight += kRetweetedWeiboImageWidth + 8.0
                    cell.retweetedContainerHeight.constant = retweetedViewHeight
                    
                    cell.retweetedImageContainer.hidden = false
                    cell.retweetedImageContainerHeight.constant = kRetweetedWeiboImageWidth
                    // back to default position when imageViewContainer appears again
                    cell.retweetedImageContainer.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
                    
                    for var i = 0 ; i < numberOfRetweetedImages ; i++ {
                        cell.retweetedImages[i].hidden = false
                        let widthOfRetweetedImageContainer: CGFloat = (kRetweetedWeiboImageWidth + 8) * CGFloat(numberOfRetweetedImages)
                        if numberOfRetweetedImages <= 3{
                            cell.retweetedImageContainerWidth.constant = widthOfRetweetedImageContainer - 8.0
                            cell.retweetedImageContainer.scrollEnabled = false
                        }else{
                            cell.retweetedImageContainerWidth.constant = kScreenWidth - 34.0
                            cell.retweetedImageContainer.scrollEnabled = true
                        }
                        cell.retweetedImageContainer.contentSize = CGSize(width: widthOfRetweetedImageContainer, height: kRetweetedWeiboImageWidth)
                        let retweetedStatusImage = retweetedStatus.images[i] as! StatusImage
                        let retweetedStatusImageUrl = NSURL(string: retweetedStatusImage.thumbnailImageUrl)

                        cell.retweetedImages[i].kf_setImageWithURL(retweetedStatusImageUrl!, placeholderImage: UIImage(named: "image_holder"))
                        
                    }
                    
                }
                
            }
            else{
                retweetedViewHeight = 0.0
                cell.retweetedContainerHeight.constant = 0
                cell.retweetedWeiboText.text = nil
                cell.retweetedImageContainerHeight.constant = 0
                for object in cell.retweetedImages{
                    object.hidden = true
                }
            }
            tableView.rowHeight = rowHeight + retweetedViewHeight + 21.0 + 8.0
        }
    }

}