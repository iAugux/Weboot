//
//  AppDelegate.swift
//  iAugus
//
//  Created by Augus on 4/27/15.
//  Copyright (c) 2015 Augus. All rights reserved.
//

import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var wbToken: NSString?
    var wbCurrentUserID: NSString?
    var window: UIWindow?
    var storyboard = UIStoryboard(name: "Main", bundle: nil)
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        
        // SlideMenu
        application.statusBarStyle = .LightContent
        let containerViewController = ContainerViewController()
        var homeNav = storyboard.instantiateViewControllerWithIdentifier("homeNav") as! UINavigationController
        homeNav.viewControllers[0] = containerViewController
        homeNav.setNavigationBarHidden(true, animated: false)
        window?.rootViewController = homeNav
        
        
//        // Link with Weibo SDK
//        WeiboSDK.enableDebugMode(true)
//        println("start redisterApp")
//        WeiboSDK.registerApp(weiboAppKey)
//        println("registerApp end")
//        
        
        
    
        let weibo:Weibo = Weibo(appKey: weiboAppKey, withAppSecret: weiboAppSecret)
        Weibo.setWeibo(weibo)
        if weibo.isAuthenticated(){
            NSLog("current user: \(weibo.currentAccount().user.name)")
        }
//        WeiboAuthentication(authorizeURL: authorizeURL, accessTokenURL: nil, appKey: weiboAppKey, appSecret: weiboAppSecret)
        
      
        
        return true
    }
    
    
    
//    func application(application: UIApplication, openURL url:NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
//        
//        return WeiboSDK.handleOpenURL(url , delegate: self)
//    }
//    
//    func application(application: UIApplication, handleOpenURL url: NSURL) -> Bool {
//        return WeiboSDK.handleOpenURL(url , delegate: self)
//    }
//    
//    func didReceiveWeiboRequest(request: WBBaseRequest!) {
//        if (request.isKindOfClass(WBProvideMessageForWeiboRequest)) {
//            //TODO: sth
//        }
//    }
//    func didReceiveWeiboResponse(response: WBBaseResponse!) {
//        if (response.isKindOfClass(WBSendMessageToWeiboResponse)) {
//            var message = "响应状态:\(response.statusCode.rawValue)\n响应UserInfo数据:\(response.userInfo)\n原请求UserInfo数据:\(response.requestUserInfo)"
//            var alert = UIAlertView(title: "发送结果", message: message, delegate: nil, cancelButtonTitle: "确定")
//            let wbAuthorize :WBAuthorizeResponse = response as! WBAuthorizeResponse
//            var accessToken = wbAuthorize.accessToken
//            if let token = accessToken {
//                self.wbToken = accessToken
//            }
//            var userID = wbAuthorize.userID
//            if let id = userID{
//                self.wbCurrentUserID = userID
//            }
//            
//            alert.show()
//        } else if (response.isKindOfClass(WBAuthorizeResponse)) {
//            var message = "响应状态: \(response.statusCode.rawValue)\nresponse.userId: \((response as! WBAuthorizeResponse).userID)\nresponse.accessToken: \((response as! WBAuthorizeResponse).accessToken)\n响应UserInfo数据: \(response.userInfo)\n原请求UserInfo数据: \(response.requestUserInfo)"
//            var alert = UIAlertView(title: "认证结果", message: message, delegate: nil, cancelButtonTitle: "确定")
//            alert.show()
//        }
//    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}

