//
//  UserDefaults+Extensions.swift
//  Appella Health
//
//  Created by F.Q. on 27.03.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation

enum UserDefaultsKeys {
    static let userId = "userId"
}

extension UserDefaults {
    static func setUserId(_ userId: String?) {
        UserDefaults.standard.set(userId, forKey: UserDefaultsKeys.userId)
    }
    
    static func getUserId() -> String? {
        return UserDefaults.standard.string(forKey: UserDefaultsKeys.userId)
    }
}
