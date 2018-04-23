//
//  MainViewController.swift
//  Appella Health
//
//  Created by F.Q. on 27.03.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import SideMenu
import SVProgressHUD

protocol MainViewControllerDelegate: class {
    func didSelectArticleWith(id: Int)
}

class MainViewController: BaseViewController {
    
    //MARK: - Properties
    
    private var kitchen: MainKitchen!
    
    //MARK: - Outlets
    
    @IBOutlet private var mainView: MainView! {
        didSet {
            mainView.delegate = self
        }
    }
    
    //MARK: - Dependency Injection
    
    func inject(kitchen: MainKitchen) {
        self.kitchen = kitchen
    }
    
    //MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let sideMenuStoryboard = UIStoryboard.sideMenu
        guard let sideMenuController = sideMenuStoryboard.instantiateInitialViewController() else {
            fatalError("Failed to instantiateInitialViewController for SideMenu Storyboard")
        }
        let menuLeftNavigationController = UISideMenuNavigationController(rootViewController: sideMenuController)
        SideMenuManager.default.menuLeftNavigationController = menuLeftNavigationController
        removeBackButtonTitle()
        navigationController?.navigationBar.setGradientBackground(colors: [.black, .clear])
        addTextToRightBarItem(text: NSLocalizedString("Appella Health", comment: ""))
        setMenuIcon(#selector(didTapSideMenuButton))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        kitchen.receive(event: .viewWillAppear)
    }
    
    //MARK: - Navigation
    
    private func openHelpDesk() {
        let storyboard = UIStoryboard.helpDesk
        guard let viewController = storyboard.instantiateInitialViewController() else {
            fatalError("Fail to instantiatiate initial view controller of help desk storyboard")
        }
        navigationController?.pushViewController(viewController, animated: false)
    }
    
    private func openAccount() {
        let storyboard = UIStoryboard.account
        guard let viewController = storyboard.instantiateInitialViewController() else {
            fatalError("Fail to instantiatiate initial view controller of account storyboard")
        }
        navigationController?.pushViewController(viewController, animated: false)
    }
    
    //MARK: - Actions
    
    @objc func didTapSideMenuButton() {
        showMenu()
    }
    
    //MARK: - View State Change
    
    private func handleChangeOf(viewState: MainViewState) {
        mainView.configure(viewState: viewState)
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
        case .startLoading:
            SVProgressHUD.show()
        case .finishLoading:
            SVProgressHUD.dismiss()
        case .errorHappend(let error):
            SVProgressHUD.showError(withStatus: error)
        case .articlesLoaded(let viewState):
            handleChangeOf(viewState: viewState)
        case .logout:
            Logout.perform()
        case .categoryDidChange:
            navigationController?.popToRootViewController(animated: false)
        }
    }
}

//MARK: - MainView Controller Delegate

extension MainViewController: MainViewControllerDelegate {
    func didSelectArticleWith(id: Int) {
        let storyboard = UIStoryboard.article
        guard let viewController = storyboard.instantiateInitialViewController() as? ArticleViewController else {
            fatalError("Unexpected view controller")
        }
        viewController.setup(articleId: id, articlesCategory: kitchen.currentCategory)
        navigationController?.show(viewController, sender: self)
    }
}

//MARK: - Remove Back Button Title

extension MainViewController: RemoveBackButtonTitle {
    
}

//MARK: - Add Label To Right Bar Item

extension MainViewController: AddLabelToRightBarItem {
    
}

//MARK: - MenuIcon

extension MainViewController: MenuIcon {
    
}
