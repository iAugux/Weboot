//
//  Tools.swift
//  iAugus
//
//  Created by Augus on 4/26/15.
//  Copyright (c) 2015 Augus. All rights reserved.
//

import UIKit

// get the height of Screen
let ScreenHeight = UIScreen.mainScreen().bounds.height

// get the width of Screen
let ScreenWidth = UIScreen.mainScreen().bounds.width

// set Weibo Appkey
let weiboAppKey:String = "244849822"

// set weibo AppSecret
let weiboAppSecret:String = "c489a36fc2ba7aa130114cfa680df1a8"

// set authorizeURL
let authorizeURL = "https://api.weibo.com/oauth2/authorize"

// set row number of Timeline
var numberOfTimelineRow: Int32 = 50

// set width of original image
let originalWeiboImageWidth: CGFloat = 110

// set width of retweeted image
let retweetedWeiboImageWidth: CGFloat = 90.0

// set size of retweeted weibo text size
var RETWEETED_FONT_SIZE: CGFloat = 15.0

// set size of retweeted weibo text width
var RETWEETED_TEXT_WIDTH: Float = 283

var ORIGINAL_FONT_SIZE: CGFloat = 17.0

var ORIGINAL_TEXT_WIDTH: Float = 294.0

var WEIBO_HEADER: CGFloat = 52.0