//
//  NotificationStatus.swift
//  Appella Health
//
//  Created by F.Q. on 28.03.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation

struct NotificationStatusResponse: Codable {
    let responseParameters: [String]
    let responseData: NotificationStatusResponseData
    
    enum CodingKeys: String, CodingKey {
        case responseParameters = "responseparameters"
        case responseData
    }
}

struct NotificationStatusResponseData: Codable {
    let userId: String
    let pushNotificationStatus: String
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case pushNotificationStatus = "push_notification_status"
    }
    func getStatus() -> Bool {
        guard let int = Int(pushNotificationStatus) else {
            return false
        }
        if int == 0 {
            return false
        }
        if int == 1 {
            return true
        }
        return false
    }
}
