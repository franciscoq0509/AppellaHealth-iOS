//
//  User.swift
//  Appella Health
//
//  Created by F.Q. on 26.03.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

struct UserResponse: Codable {
    let responseData: UserContainer
}

struct UserContainer: Codable {
    let user: User
    
    enum CodingKeys: String, CodingKey {
        case user = "1"
    }
}

struct User: Codable {
    let userId: String
    let userName: String
    let email: String
    let password:String
    let image: String
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case userName = "username"
        case email
        case password
        case image
    }
}
