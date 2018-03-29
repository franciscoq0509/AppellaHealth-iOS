//
//  ForgotPasswordKitchen.swift
//  Appella Health
//
//  Created by F.Q. on 27.03.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

enum ForgotPasswordViewEvent {
    case didTapSubmit(email: String)
}

enum ForgotPasswordState {
    case startLoading
    case finishLoading
    case loaded(message: String)
    case errorHappend(error: String)
}

class ForgotPasswordKitchen: Kitchen {
    typealias ViewEvent = ForgotPasswordViewEvent
    typealias Command = ForgotPasswordState
    
    var delegate: AnyKitchenDelegate<ForgotPasswordState>?
    let networkManager: NetworkManager!
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    func receive(event: ViewEvent) {
        switch event {
        case .didTapSubmit(let email):
            remindPassword(email: email)
        }
    }
        
    func remindPassword(email: String) {
        self.delegate?.perform(.startLoading)
        networkManager.remindPassword(email: email).onSuccess { [weak self] message in
            guard let _self = self else {
                return
            }
            _self.delegate?.perform(.finishLoading)
            _self.delegate?.perform(.loaded(message: message))
        }.onFailure { [weak self] error in
            guard let _self = self else {
                return
            }
            _self.delegate?.perform(.finishLoading)
            _self.delegate?.perform(.errorHappend(error: error.message))
        }
    }
}
