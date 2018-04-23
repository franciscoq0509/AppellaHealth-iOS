//
//  MainKitchen.swift
//  Appella Health
//
//  Created by F.Q. on 28.03.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation

enum MainViewEvent {
    case viewWillAppear
}

enum MainState {
    case startLoading
    case finishLoading
    case articlesLoaded(viewState: MainViewState)
    case openHelpDesk
    case openAccount
    case errorHappend(error: String)
    case logout
    case categoryDidChange
}

protocol MainKitchenDelegate: class {
    func categoryDidChange(_ category: ArticleCategory)
}

class MainKitchen: Kitchen {
    typealias ViewEvent = MainViewEvent
    typealias Command = MainState
    
    var delegate: AnyKitchenDelegate<Command>?
    let networkManager: NetworkManager
    let mainViewStateFactory: MainViewStateFactory
    var currentCategory: ArticleCategory = .news
    
    init(networkManager: NetworkManager, mainViewStateFactory: MainViewStateFactory) {
        self.networkManager = networkManager
        self.mainViewStateFactory = mainViewStateFactory
    }
    
    func receive(event: ViewEvent) {
        switch event {
        case .viewWillAppear:
            loadNews()
        }
    }
    
    func loadNews() {
        delegate?.perform(.startLoading)
        networkManager.getArticles(category: currentCategory).onSuccess { [weak self] articles in
            guard let _self = self else {
                return
            }
            _self.delegate?.perform(.finishLoading)
            let viewState = _self.mainViewStateFactory.make(articles)
            _self.delegate?.perform(.articlesLoaded(viewState: viewState))
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
}

extension MainKitchen: MainKitchenDelegate {
    func categoryDidChange(_ category: ArticleCategory) {
        switch category {
        case .helpDesk:
            delegate?.perform(.openHelpDesk)
        case .account:
            delegate?.perform(.openAccount)
        case .appellaHealth:
            break
        default:
            currentCategory = category
            delegate?.perform(.categoryDidChange)
            loadNews()
        }
    }
}
