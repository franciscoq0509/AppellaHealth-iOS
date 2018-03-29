//
//  LoginKitchen.swift
//  Appella Health
//
//  Created by F.Q. on 26.03.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation

enum LoginViewEvent {
    case didTapLogin(login: String, password: String)
}

enum LoginState {
    case startLoading
    case logined
    case finishLoading
    case errorHappend(String)
}

class LoginKitchen: Kitchen {
    typealias ViewEvent = LoginViewEvent
    typealias Command = LoginState
    
    var delegate: AnyKitchenDelegate<LoginState>?
    
    private let networkManager: NetworkManager
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    func receive(event: ViewEvent) {
        switch event {
        case .didTapLogin(let login, let password):
            makeLogin(login: login, password: password)
        }
    }
    
    func makeLogin(login: String, password: String) {
        delegate?.perform(.startLoading)
        networkManager.login(login: login, password: password).onSuccess { [weak self] user in
            guard let _self = self else {
                return
            }
            _self.delegate?.perform(.finishLoading)
            UserDefaults.setUserId(user.userId)
            _self.delegate?.perform(.logined)
        }.onFailure { [weak self] error in
            guard let _self = self else {
                return
            }
            _self.delegate?.perform(.finishLoading)
            _self.delegate?.perform(.errorHappend(error.message))
        }
    }
}
