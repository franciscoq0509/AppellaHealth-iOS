//
//  Optional+Ibaat.swift
//  Ibaat
//
//  Created by F.Q. on 26.03.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

extension Optional where Wrapped: AnyObject {
    public func strongSelf(file: String = #file, method: String = #function, line: UInt = #line) -> Wrapped? {
        guard let strongSelf = self else {
            return nil
        }
        return strongSelf
    }
}
