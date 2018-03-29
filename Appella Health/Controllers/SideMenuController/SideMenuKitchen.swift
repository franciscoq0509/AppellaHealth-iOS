//
//  SideMenuKitchen.swift
//  Appella Health
//
//  Created by F.Q. on 28.03.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation

enum SideMenuViewEvent {
    case disSelectCategory(category: ArticleCategory)
}

enum SideMenuState {
    
}

class SideMenuKitchen: Kitchen {
    typealias ViewEvent = SideMenuViewEvent
    typealias Command = SideMenuState
    
    var delegate: AnyKitchenDelegate<Command>?
    private weak var mainKitchenDelegate: MainKitchenDelegate?
    
    init(mainKitchenDelegate: MainKitchenDelegate) {
        self.mainKitchenDelegate = mainKitchenDelegate
    }
    
    func receive(event: ViewEvent) {
        switch event {
        case .disSelectCategory(let category):
            mainKitchenDelegate?.categoryDidChange(category)
        }
    }
    
}
