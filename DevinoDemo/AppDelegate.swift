//
//  AppDelegate.swift
//  DevinoDemo
//
//  Created by Alexej Nenastev on 31.05.2018.
//  Copyright © 2018 Alexej Nenastev. All rights reserved.
//

import UIKit
import DevinoSDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    let appGroupId = "group.com.fruktorum.DevinoPush"
    let devinoUNUserNotificationCenter = DevinoUNUserNotificationCenter()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // set Devino configurations:
        let config = Devino.Configuration(key: "d223165e-e7aa-4619-a3b0-50c5826494db", applicationId: 13, appGroupId: appGroupId, geoDataSendindInterval: 1)
        Devino.shared.activate(with: config)
        Devino.shared.trackLaunchWithOptions(launchOptions)
        // registration process with Apple Push Notification service:
        application.registerForRemoteNotifications()
        // assign delegate object to the UNUserNotificationCenter object:
        UNUserNotificationCenter.current().delegate = devinoUNUserNotificationCenter
        activateAppByTapOnNotification(launchOptions)
        configureNotificationActions()
        return true
    }

    func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, for notification: UILocalNotification, completionHandler: @escaping () -> Void) {
//        Devino.shared.trackLocalNotification(notification, with: identifier)
        completionHandler()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        Devino.shared.trackAppTerminated()
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Devino.shared.registerForNotification(deviceToken)
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        UIApplication.shared.applicationIconBadgeNumber = 0
        Devino.shared.trackAppLaunch()
    }
    
    public func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        completionHandler(.newData)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Push notifications Error - \(error.localizedDescription)")
    }
    
    private func configureNotificationActions() {
        devinoUNUserNotificationCenter.setActionForUrl { str in 
            if str == "devino://first" {
                self.goToDeepLinkVC()
            }
        }
    }
    
    private func goToDeepLinkVC() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "deepLinkViewController") as! DeepLinkViewController
        UIApplication.shared.windows.first?.rootViewController = vc
    }
    
    private func activateAppByTapOnNotification(_ launchOptions: [UIApplicationLaunchOptionsKey: Any]?) {
        if launchOptions?[UIApplicationLaunchOptionsKey.remoteNotification] != nil {
            if let options = launchOptions, let userInfo = options[UIApplication.LaunchOptionsKey.remoteNotification] as? [AnyHashable: Any] {
//                Devino.shared.trackReceiveRemoteNotification(userInfo)
            }
        }
    }
}
