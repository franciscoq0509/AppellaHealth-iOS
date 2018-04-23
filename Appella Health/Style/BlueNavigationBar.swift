//
//  BlueNavigationBar.swift
//  Appella Health
//
//  Created by F.Q. on 27.03.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

protocol BlueNavigationBar {
    
    var navigationController: UINavigationController? {get}
    
    func setupNavigationBar()
}

extension BlueNavigationBar {
    func setupNavigationBar() {
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.barTintColor = AppellaHealthColors.navigationBarBlueColor
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
    }
}
