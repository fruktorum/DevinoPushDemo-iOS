//
//  AppDelegate.swift
//  DevinoDemo
//
//  Created by Alexej Nenastev on 31.05.2018.
//  Copyright © 2018 Alexej Nenastev. All rights reserved.
//

import UIKit
import UserNotifications
import DevinoSDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
        }
        
        let config = Devino.Configuration(key: "key=KjTeZZpPW4s63PpMEYpgKIj55DTACr8_Whqh5Rir")
        Devino.shared.activate(with: config)
        Devino.shared.trackLaunchWithOptions(launchOptions)
        application.registerForRemoteNotifications()
 
        return true
    }

    func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, for notification: UILocalNotification, completionHandler: @escaping () -> Void) {
        Devino.shared.trackLocalNotification(notification, with: identifier)
        completionHandler()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        Devino.shared.trackAppTerminated()
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Devino.shared.registerForNotification(deviceToken)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        Devino.shared.trackReceiveRemoteNotification(userInfo)
        completionHandler(.newData)
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        Devino.shared.trackAppLaunch()
    }
}

extension AppDelegate : UNUserNotificationCenterDelegate {
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Swift.Void)
    {
        Devino.shared.trackNotificationResponse(response)
        completionHandler()
    }
 
}
