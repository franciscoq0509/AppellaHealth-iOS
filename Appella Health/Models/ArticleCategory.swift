//
//  Categories.swift
//  Appella Health
//
//  Created by F.Q. on 27.03.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation

enum ArticleCategory: Int {
    case news = 1
    case humanResource = 2
    case informationTechnology = 3
    case events = 4
    case dining = 5
    case nursing = 8
    case photoGallery = 9
    case helpDesk
    case account
    case appellaHealth
    
    static let allCategories = [news, humanResource, informationTechnology, events, dining, nursing, photoGallery, helpDesk, account, appellaHealth]
    
    var describing: String {
        switch self {
        case .news:
            return NSLocalizedString("News", comment: "")
        case .humanResource:
            return NSLocalizedString("Human Resource", comment: "")
        case .informationTechnology:
            return NSLocalizedString("Information Technology", comment: "")
        case .events:
            return NSLocalizedString("Events", comment: "")
        case .dining:
            return NSLocalizedString("Dining", comment: "")
        case .nursing:
            return NSLocalizedString("Nursing", comment: "")
        case .photoGallery:
            return NSLocalizedString("Photo Gallery", comment: "")
        case .helpDesk:
            return NSLocalizedString("Help Desk", comment: "")
        case .account:
            return NSLocalizedString("Account", comment: "")
        case .appellaHealth:
            return NSLocalizedString("Appella Health", comment: "")
        }
    }
}
