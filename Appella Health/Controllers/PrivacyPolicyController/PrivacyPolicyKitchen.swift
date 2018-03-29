//
//  PrivacyPolicyKitchen.swift
//  Appella Health
//
//  Created by F.Q. on 28.03.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation

enum PrivacyPolicyViewEvent {
    case viewWillAppear
}

enum PrivacyPolicyState {
    case startLoading
    case finishLoading
    case textLoaded(text: String)
    case errorHappend(error: String)
}

class PrivacyPolicyKitchen: Kitchen {
    typealias ViewEvent = PrivacyPolicyViewEvent
    typealias Command = PrivacyPolicyState
    
    var delegate: AnyKitchenDelegate<PrivacyPolicyState>?
    let networkManager: NetworkManager
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    func receive(event: PrivacyPolicyViewEvent) {
        switch event {
        case .viewWillAppear:
            loadText()
        }
    }
    
    func loadText() {
        delegate?.perform(.startLoading)
        networkManager.getPrivacyPolicy().onSuccess { [weak self] text in
            guard let _self = self else {
                return
            }
            _self.delegate?.perform(.finishLoading)
            _self.delegate?.perform(.textLoaded(text: text))
        }.onFailure { [weak self] error in
            guard let _self = self else {
                return
            }
            _self.delegate?.perform(.finishLoading)
            _self.delegate?.perform(.errorHappend(error: error.message))
        }
    }
}
