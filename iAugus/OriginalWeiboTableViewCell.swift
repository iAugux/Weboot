//
//  OriginalWeiboTableViewCell.swift
//  iAugus
//
//  Created by Augus on 5/11/15.
//  Copyright (c) 2015 Augus. All rights reserved.
//

import UIKit

class OriginalWeiboTableViewCell: UITableViewCell {
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var screenName: UILabel!
//    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var originalWeiboText: UILabel!
    @IBOutlet weak var createdDate: UILabel!
    @IBOutlet weak var weiboSource: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code  
        userImage.layer.cornerRadius = 20.0
        userImage.clipsToBounds = true
        initControllers()
    }
    
    func initControllers(){
        screenName.text = nil
        originalWeiboText.text = nil
        createdDate.text = nil
        weiboSource.text = nil
   
    }
   
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
