//
//  PageResponse.swift
//  Appella Health
//
//  Created by F.Q. on 28.03.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation

struct PrivacyPolicyResponse: Codable {
    let status: ResponseStatus
    let privacyPolicy: PrivacyPolicy
    
    enum CodingKeys: String, CodingKey {
        case status
        case privacyPolicy = "payload"
    }
}

struct PrivacyPolicy: Codable {
    let privacyPolicy: String
    
    enum CodingKeys: String, CodingKey {
        case privacyPolicy = "privacy_policy"
    }
}
