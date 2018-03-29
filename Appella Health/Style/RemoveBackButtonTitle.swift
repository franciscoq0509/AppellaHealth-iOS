//
//  RemoveBackButtonTitle.swift
//  Appella Health
//
//  Created by F.Q. on 28.03.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

protocol RemoveBackButtonTitle {
    var navigationItem: UINavigationItem {get}
    
    func removeBackButtonTitle()
}

extension RemoveBackButtonTitle {
    
    func removeBackButtonTitle() {
         navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}
