//
//  PageResponse.swift
//  Appella Health
//
//  Created by F.Q. on 28.03.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation

struct PageResponse: Codable {
    let responseParameters: [String]
    let responseData: PageResponseData
    
    enum CodingKeys: String, CodingKey {
        case responseParameters = "responseparameters"
        case responseData
    }
}

struct PageResponseData: Codable {
    let result: String
    let message: String
    let id: String
    let pageHeader: String
    let content: String
    
    enum CodingKeys: String, CodingKey {
        case pageHeader = "page_header"
        case result
        case message
        case id
        case content
    }
}
