//
//  RegisterKitchen.swift
//  Appella Health
//
//  Created by F.Q. on 27.03.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation

enum RegisterViewEvent {
    case didTapRegister(firstName: String, lastName: String, email: String, password: String)
}

enum RegisterState {
    case startLoading
    case finishLoading
    case registered(String)
    case errorHappend(String)
}

class RegisterKitchen: Kitchen {
    typealias ViewEvent = RegisterViewEvent
    typealias Command = RegisterState
    
    var delegate: AnyKitchenDelegate<RegisterState>?
    
    let networkManager: NetworkManager
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    func receive(event: ViewEvent) {
        switch event {
        case .didTapRegister(let firstName, let lastName, let email, let password):
            register(firstName: firstName, lastName: lastName, email: email, password: password)
        }
    }
    
    func register(firstName: String, lastName: String, email: String, password: String) {
        self.delegate?.perform(.startLoading)
        networkManager.register(firstName: firstName, lastName: lastName, email: email, password: password).onSuccess { [weak self] message in
            guard let _self = self else {
                return
            }
            _self.delegate?.perform(.finishLoading)
            _self.delegate?.perform(.registered(message))
            }.onFailure { [weak self] error in
                guard let _self = self else {
                    return
                }
                _self.delegate?.perform(.finishLoading)
                _self.delegate?.perform(.errorHappend(error.message))
        }
    }
}
