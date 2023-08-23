//
//  AppDelegate.swift
//  DevinoDemo
//
//  Created by Alexej Nenastev on 31.05.2018.
//  Copyright © 2018 Alexej Nenastev. All rights reserved.
//

import UIKit
import DevinoSDK
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    let appGroupId = "group.com.fruktorum.DevinoPush"
    let devinoUNUserNotificationCenter = DevinoUNUserNotificationCenter()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // set Devino configurations:
        var applicationId = 0
        #if DEBUG
        applicationId = 127
        #else
        applicationId = 126
        #endif
        let config = Devino.Configuration(key: "5e2411c9-afa8-4434-b8b1-3e42369fa803", applicationId: applicationId, appGroupId: appGroupId, geoDataSendindInterval: 1, apiRootUrl: Constants.apiUrl, apiRootPort: 6602)
        Devino.shared.activate(with: config)
        Devino.shared.trackLaunchWithOptions(launchOptions)
        // registration process with Apple Push Notification service:
        application.registerForRemoteNotifications()
        // assign delegate object to the UNUserNotificationCenter object:
        UNUserNotificationCenter.current().delegate = devinoUNUserNotificationCenter
        activateAppByTapOnNotification(launchOptions)
        configureNotificationActions()
        //reset status before entering
        UserDefaults.standard.set(false, forKey: "status")
        //setup IQKeyboardManager
        IQKeyboardManager.shared.enable = true
        return true
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
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
        Devino.shared.trackReceiveRemoteNotification(userInfo, appGroupsId: appGroupId)
        completionHandler(.newData)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Push notifications Error - \(error.localizedDescription)")
    }
    
    // For Deep Link
    private func configureNotificationActions() {
        devinoUNUserNotificationCenter.setActionForUrl { str in
            if str == "devino://first" {
                self.goToDeepLinkVC()
            } else if str == "devino://second" {
                self.goToActionLinkVC()
            } else if let url = URL(string: str) {
                UIApplication.shared.open(url)
            }
        }
        
        // For action link
        devinoUNUserNotificationCenter.setActionForCustomDefault { str in
            if str == "devino://second" {
                self.goToActionLinkVC()
            } else if let url = URL(string: str) {
                UIApplication.shared.open(url)
            }
        }
    }
    
    private func goToDeepLinkVC() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "deepLinkViewController") as! DeepLinkViewController
        UIApplication.shared.windows.first?.rootViewController = vc
    }
    
    private func goToActionLinkVC() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "actionLinkViewController") as! ActionLinkViewController
        UIApplication.shared.windows.first?.rootViewController = vc
    }
    
    private func activateAppByTapOnNotification(_ launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        if launchOptions?[UIApplication.LaunchOptionsKey.remoteNotification] != nil {
            if let options = launchOptions, let userInfo = options[UIApplication.LaunchOptionsKey.remoteNotification] as? [AnyHashable: Any] {
                Devino.shared.trackReceiveRemoteNotification(userInfo, appGroupsId: appGroupId)
            }
        }
    }
}

