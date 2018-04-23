//
//  MenuIcon.swift
//  Appella Health
//
//  Created by F.Q. on 19.04.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation
import UIKit
import SideMenu

protocol MenuIcon: class {
    var navigationItem: UINavigationItem {get}
    var view: UIView! {get}
    func setMenuIcon(_ selector: Selector)
    func present(_ viewController: UIViewController, animated: Bool, completion: (() -> Void)?)
}

extension MenuIcon {
    func setMenuIcon(_ selector: Selector) {
        SideMenuManager.default.menuAddPanGestureToPresent(toView: view)
        navigationItem.hidesBackButton = true
        let menuBarButton = UIBarButtonItem(image: #imageLiteral(resourceName: "menuIcon"), style: .plain, target: self, action: selector)
        navigationItem.leftBarButtonItem = menuBarButton
    }
    
    func showMenu() {
        guard let sideMenu = SideMenuManager.default.menuLeftNavigationController else {
            return
        }
        present(sideMenu, animated: true, completion: nil)
    }
}
