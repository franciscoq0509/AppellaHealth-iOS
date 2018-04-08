//
//  ResponseData.swift
//  Appella Health
//
//  Created by F.Q. on 27.03.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation

enum ResponseStatus: String, Codable {
    case ok
    case error
}

struct Response: Codable {
    let status: ResponseStatus
    
    let responseMessage: ResponseMessage
    
    init?(_ data: Data) {
        do {
            self = try JSONDecoder().decode(Response.self, from: data)
        }
        catch {
            print(error)
            return nil
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case status
        case responseMessage = "payload"
    }
}

struct ResponseMessage: Codable {
    let message: String
}
