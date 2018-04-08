//
//  UserInfo.swift
//  Appella Health
//
//  Created by F.Q. on 03.04.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation

struct UserInfoResponse: Codable {
    let status: ResponseStatus
    let userInfo: UserInfo
    
    enum CodingKeys: String, CodingKey {
        case status
        case userInfo = "payload"
    }
}

struct UserInfo: Codable {
    let active: Int
    let isAdmin: Int
    let email: String
    let notifications: Int
    
    enum CodingKeys: String, CodingKey {
        case active
        case isAdmin = "is_admin"
        case email
        case notifications
    }
}
