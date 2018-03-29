//
//  MainViewController.swift
//  Appella Health
//
//  Created by F.Q. on 27.03.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import SideMenu

class MainViewController: BaseViewController {
    
    //MARK: - Properties
    
    var kitchen: MainKitchen!
    
    //MARK: - Outlets
    
    @IBOutlet private var tableView: UITableView!
    
    //MARK: - Dependency Injection
    
    func inject(kitchen: MainKitchen) {
        self.kitchen = kitchen
    }
    
    //MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.shared.statusBarStyle = .lightContent
        SideMenuManager.default.menuAddScreenEdgePanGesturesToPresent(toView: view)
        removeBackButtonTitle()
        navigationController?.navigationBar.setGradientBackground(colors: [.black, .clear])
        addTextToRightBarItem(text: NSLocalizedString("Appella Health", comment: ""))
    }
    
    //MARK: - Navigation
    
    func openHelpDesk() {
        let storyboard = UIStoryboard.helpDesk
        guard let viewController = storyboard.instantiateInitialViewController() else {
            fatalError("Fail to instantiatiate initial view controller of help desk storyboard")
        }
        navigationController?.pushViewController(viewController, animated: false)
    }
    
    func openAccount() {
        let storyboard = UIStoryboard.account
        guard let viewController = storyboard.instantiateInitialViewController() else {
            fatalError("Fail to instantiatiate initial view controller of account storyboard")
        }
        navigationController?.pushViewController(viewController, animated: false)
    }
}

//MARK: - Kitchen Delegate

extension MainViewController: KitchenDelegate {
    typealias Command = MainState
    
    func perform(_ command: Command) {
        switch command {
        case .openAccount:
            openAccount()
        case .openHelpDesk:
            openHelpDesk()
        }
    }
}

//MARK: - Remove Back Button Title

extension MainViewController: RemoveBackButtonTitle {
    
}

//MARK: - Add Label To Right Bar Item

extension MainViewController: AddLabelToRightBarItem {
    
}
