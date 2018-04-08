//
//  ErrorHandler.swift
//  Appella Health
//
//  Created by F.Q. on 06.04.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation

enum ErrorCode: Int {
    case unauthorized = 401
}

class ErrorHandler {
    func handle(errorCode: ErrorCode) -> Swift.Error {
        switch errorCode {
        case .unauthorized:
            return InvalidTokenError()
        }
    }
}
