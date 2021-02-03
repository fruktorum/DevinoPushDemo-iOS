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
    
//    override var appGroupsId: String? {
//        return "group.com.fruktorum.DevinoPush"
//    }
    
    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        
        super.didReceive(request, withContentHandler: contentHandler)
        // Your code
    }
    
}
