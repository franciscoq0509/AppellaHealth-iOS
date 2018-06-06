//
//  PushNotificationsManager.swift
//  Appella Health
//
//  Created by F.Q. on 30.04.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation
import OneSignal
import BrightFutures

class PushNotificationsManager {
    
    private let networkManager: NetworkManager
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    @discardableResult
    func setNotificationsStatus(_ status: Bool) -> Future<String, AnyError> {
        let promise = Promise<String, AnyError>()
        networkManager.switchNotificationStatus(status: status).onSuccess { message in
            OneSignal.setSubscription(status)
            promise.success(message)
        }.onFailure { error in
            promise.failure(error)
        }
        return promise.future
    }
}
