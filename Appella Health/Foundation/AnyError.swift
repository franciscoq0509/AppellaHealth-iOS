//
//  AnyError.swift
//  Addicted
//
//  Created by F.Q. on 07.02.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation

/// Protocol used to constrain `tryMap` to `Result`s with compatible `Error`s.
public protocol ErrorConvertible: Swift.Error {
    static func error(from error: Swift.Error) -> Self
}

/// A type-erased error which wraps an arbitrary error instance. This should be
/// useful for generic contexts.
public struct AnyError: Swift.Error {
    
    private var messageString: String?
    /// The underlying error.
    public let error: Swift.Error
    
    public var message: String {
        get {
            guard let message = messageString else {
                return error.localizedDescription
            }
            return message
        }
    }
    
    public init(_ error: Swift.Error) {
        if let anyError = error as? AnyError {
            self = anyError
        }
        else {
            self.error = error
        }
    }
    public init(_ message: String) {
        self.error = NSError(domain: message, code: 1, userInfo: nil)
        self.messageString = message
    }
}

extension AnyError: ErrorConvertible {
    public static func error(from error: Error) -> AnyError {
        return AnyError(error)
    }
}

extension AnyError: CustomStringConvertible {
    public var description: String {
        return String(describing: error)
    }
}
