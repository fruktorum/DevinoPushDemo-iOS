//
//  NotificationService.swift
//  NotificationService
//
//  Created by Герасимов Тимофей Владимирович on 17/10/2019.
//  Copyright © 2019 Alexej Nenastev. All rights reserved.
//

import DevinoSDK
import UserNotifications

class NotificationService: DevinoNotificationService {
    
    public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }

    public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let actionIdentifier = response.actionIdentifier
        print("ACTION ID = \(actionIdentifier)")
        /// Identify the action by matching its identifier.
        switch actionIdentifier {
        case UNNotificationDefaultActionIdentifier:
            Devino.shared.trackNotificationResponse(response)
            if let actionButton = response.notification.request.content.userInfo["action"] as? [String: String], let action = actionButton["action"] {
            }
            print("Action default")
        case UNNotificationDismissActionIdentifier:
            Devino.shared.trackNotificationResponse(response, actionIdentifier)
            print("Action dismiss")
        default:
            Devino.shared.trackNotificationResponse(response, actionIdentifier)
            print("Action = \(actionIdentifier)")
        }
        completionHandler()
    }
}
