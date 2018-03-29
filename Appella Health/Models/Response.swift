//
//  ResponseData.swift
//  Appella Health
//
//  Created by F.Q. on 27.03.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation

enum ResponseStatus: String {
    case fail
    case failed
    case success
}

struct Response: Codable {
    let responseData: ResponseData
    
    init?(_ data: Data) {
        do {
            self = try JSONDecoder().decode(Response.self, from: data)
        }
        catch {
            print(error)
            return nil
        }
    }
}

struct ResponseData: Codable {
    let message: String
    let result: String
}
