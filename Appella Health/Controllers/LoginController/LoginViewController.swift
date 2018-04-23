//
//  LoginViewController.swift
//  Appella Health
//
//  Created by F.Q. on 26.03.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import SVProgressHUD

class LoginViewController: UIViewController {
    
    //MARK: - Properties
    
    private var kitchen: LoginKitchen!
    
    //MARK: - Outlets
    
    @IBOutlet var loginTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    //MARK: - Dependency Injection
    
    func inject(kitchen: LoginKitchen) {
        self.kitchen = kitchen
    }
    
    //MARK: - View Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = true
        removeBackButtonTitle()
    }
    
    //MARK: - Actions
    
    @IBAction func didTapLogin() {
        guard let login = loginTextField.text, !login.isEmpty else {
            SVProgressHUD.showError(withStatus: NSLocalizedString("Enter email", comment: ""))
            return
        }
        guard login.isValidEmail() else {
            SVProgressHUD.showError(withStatus: NSLocalizedString("Enter valid email", comment: ""))
            return
        }
        guard let password = passwordTextField.text, !password.isEmpty else {
            SVProgressHUD.showError(withStatus: NSLocalizedString("Enter password", comment: ""))
            return
        }
        kitchen.receive(event: .didTapLogin(login: login, password: password))
    }
    
    //MARK: - Navigation
    
    func openMainPage() {
        let storyboard = UIStoryboard.main
        guard let viewController = storyboard.instantiateInitialViewController() else {
            return
        }
        navigationController?.show(viewController, sender: self)
    }
}

//MARK: - Kitchen Delegate

extension LoginViewController: KitchenDelegate {
    typealias Command = LoginState
    
    func perform(_ command: Command) {
        switch command {
        case .startLoading:
            SVProgressHUD.show()
        case .finishLoading:
            SVProgressHUD.dismiss()
        case .logined:
            openMainPage()
        case .errorHappend(let error):
            SVProgressHUD.showError(withStatus: error)
        }
    }
}

//MARK: - Remove Back Button Title

extension LoginViewController: RemoveBackButtonTitle {
    
}
