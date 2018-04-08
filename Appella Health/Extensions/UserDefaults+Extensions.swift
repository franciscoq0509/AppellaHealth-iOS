//
//  UserDefaults+Extensions.swift
//  Appella Health
//
//  Created by F.Q. on 27.03.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation

enum UserDefaultsKeys {
    static let apiKey = "apiKey"
}

extension UserDefaults {
    static func setApiKey(_ key: String?) {
        UserDefaults.standard.set(key, forKey: UserDefaultsKeys.apiKey)
    }
    
    static func getApiKey() -> String? {
        return UserDefaults.standard.string(forKey: UserDefaultsKeys.apiKey)
    }
}
