////
////  WBImagesGroupView.swift
////  Weboot
////
////  Created by Augus on 10/20/15.
////  Copyright © 2015 iAugus. All rights reserved.
////
//
//import Foundation
//
//class WBImagesGroupView: UIView {
//    var photoItemArray: NSArray!
//    
////    func initWithFrame(frame: CGRect) -> AnyObject {
////        self = super(frame: frame)
////        if self {
////            SDWebImageManager.sharedManager().imageCache.clearDisk()
////        }
////        return self
////    }
//    
//    func setPhotoItemArray2(photoItemArray: NSArray) {
//        self.photoItemArray = photoItemArray
//     
//        photoItemArray.enumerateObjectsUsingBlock { (obj: AnyObject, idx: Int , stop: UnsafeMutablePointer) -> Void in
//            let btn: UIButton = UIButton()
//            btn.imageView!.contentMode = UIViewContentMode.ScaleAspectFill
//            btn.clipsToBounds = true
//            btn.imageView?.kf_setImageWithURL(NSURL(string: (obj as! WBPhotoItemModel).thumbnail_pic)!, placeholderImage: UIImage(named: "image_holder"))
//            btn.tag = idx
//            btn.addTarget(self, action: "buttonClick", forControlEvents: .TouchUpInside)
//            self.addSubview(btn)
//        }
//       
//    }
//    
//    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        var imageCount: Int = self.photoItemArray.count
//        var perRowImageCount: Int = ((imageCount == 4) ? 2 : 3)
//        var perRowImageCountF: CGFloat = perRowImageCount
//        var totalRowCount: Int = ceil(imageCount / perRowImageCountF)
//        var w: CGFloat = 80
//        var h: CGFloat = 80
//        self.subviews.enumerateObjectsUsingBlock({(btn: UIButton, idx: UInt, stop: Bool) in
//            var rowIndex: Int = idx / perRowImageCount
//            var columnIndex: Int = idx % perRowImageCount
//            var x: CGFloat = columnIndex * (w + kImagesMargin)
//            var y: CGFloat = rowIndex * (h + kImagesMargin)
//            btn.frame = CGRectMake(x, y, w, h)
//            
//        })
//        self.frame = CGRectMake(0, 0, 280, totalRowCount * (kImagesMargin + h))
//    }
//    
//    func buttonClick(button: UIButton) {
//        var browserVc: HZPhotoBrowser = HZPhotoBrowser()
//        browserVc.sourceImagesContainerView = self
//        browserVc.imageCount = self.photoItemArray.count
//        browserVc.currentImageIndex = button.tag
//        browserVc.delegate = self
//        browserVc.show()
//    }
//    
//    func photoBrowser(browser: HZPhotoBrowser, placeholderImageForIndex index: Int) -> UIImage {
//        return self.subviews[index].currentImage()
//    }
//    
//    func photoBrowser(browser: HZPhotoBrowser, highQualityImageURLForIndex index: Int) -> NSURL {
//        var urlStr: String = self.photoItemArray[index].thumbnail_pic().stringByReplacingOccurrencesOfString("thumbnail", withString: "bmiddle")
//        return NSURL.URLWithString(urlStr)
//    }
//}