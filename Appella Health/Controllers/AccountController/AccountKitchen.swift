//
//  AccountKitchen.swift
//  Appella Health
//
//  Created by F.Q. on 28.03.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation

enum AccountViewEvent {
    case viewWillAppear
    case didLogout
    case didSwitchReceiveNotificationsStatus(status: Bool)
}

enum AccountState {
    case startLoading
    case finishLoading
    case setupNotificationStatus(status: Bool)
    case notificationStatusChanged(message: String)
    case errorHappend(error: String)
    case logout
}

class AccountKitchen: Kitchen {
    typealias ViewEvent = AccountViewEvent
    typealias Command = AccountState
    
    var delegate: AnyKitchenDelegate<Command>?
    let networkManager: NetworkManager
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    func receive(event: ViewEvent) {
        switch event {
        case .viewWillAppear:
            getNotificationStatus()
        case .didLogout:
            didLogout()
        case .didSwitchReceiveNotificationsStatus(let status):
            switchNotificationsStatus(status)
        }
    }
    
    func getNotificationStatus() {
        delegate?.perform(.startLoading)
        networkManager.getNotificationsStatus().onSuccess { [weak self] status in
            guard let _self = self else {
                return
            }
            _self.delegate?.perform(.finishLoading)
            _self.delegate?.perform(.setupNotificationStatus(status: status))
        }.onFailure { [weak self] error in
            guard let _self = self else {
                return
            }
            if error.error is InvalidTokenError {
                _self.delegate?.perform(.logout)
                return
            }
            _self.delegate?.perform(.finishLoading)
            _self.delegate?.perform(.errorHappend(error: error.message))
        }
    }
    
    func switchNotificationsStatus(_ send: Bool) {
        delegate?.perform(.startLoading)
        networkManager.switchNotificationStatus(status: send).onSuccess { [weak self] message in
            guard let _self = self else {
                return
            }
            _self.delegate?.perform(.finishLoading)
            _self.delegate?.perform(.notificationStatusChanged(message: message))
        }.onFailure { [weak self] error in
            guard let _self = self else {
                return
            }
            if error.error is InvalidTokenError {
                _self.delegate?.perform(.logout)
                return
            }
            _self.delegate?.perform(.finishLoading)
            _self.delegate?.perform(.errorHappend(error: error.message))
        }
    }
    
    private func didLogout() {
        networkManager.switchNotificationStatus(status: false)
        UserDefaults.setApiKey(nil)
    }
}
