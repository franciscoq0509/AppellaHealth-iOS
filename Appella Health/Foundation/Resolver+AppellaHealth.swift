//
//  Resolver+Ibaat.swift
//  Ibaat
//
//  Created by F.Q. on 26.03.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import Swinject

extension Resolver {
    func forceResolve<T>(_: T.Type, name: String? = nil) -> T {
        //swiftlint:disable:next force_unwrapping
        return self.resolve(T.self, name: name)!
    }
}
