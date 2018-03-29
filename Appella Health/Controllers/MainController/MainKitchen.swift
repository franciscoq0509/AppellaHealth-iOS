//
//  MainKitchen.swift
//  Appella Health
//
//  Created by F.Q. on 28.03.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation

enum MainViewEvent {
    case viewDidLoad
}

enum MainState {
    case openHelpDesk
    case openAccount
}

protocol MainKitchenDelegate: class {
    func categoryDidChange(_ category: ArticleCategory)
}

class MainKitchen: Kitchen {
    typealias ViewEvent = MainViewEvent
    typealias Command = MainState
    
    var delegate: AnyKitchenDelegate<Command>?
    
    func receive(event: ViewEvent) {
        switch event {
        case .viewDidLoad:
            loadNews()
        }
    }
    
    func loadNews(with category: ArticleCategory = .all) {
        print("ask to load \(category.rawValue)")
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
            loadNews(with: category)
        }
        
    }
}
