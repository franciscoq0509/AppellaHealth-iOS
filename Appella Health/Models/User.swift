//
//  User.swift
//  Appella Health
//
//  Created by F.Q. on 26.03.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

struct UserResponse: Codable {
    let status: ResponseStatus
    let user: User
    
    enum CodingKeys: String, CodingKey {
        case status
        case user = "payload"
    }
}

struct User: Codable {
    let firstName: String
    let lastName: String
    let email: String
    let apiKey: String
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case apiKey = "api_key"
        case email
        
    }
}
