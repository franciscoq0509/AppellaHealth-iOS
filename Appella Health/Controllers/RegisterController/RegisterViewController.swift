//
//  RegisterViewController.swift
//  Appella Health
//
//  Created by F.Q. on 27.03.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import SVProgressHUD

class RegisterViewController: BaseViewController {
    
    //MARK: - Properties
    
    private var kitchen: RegisterKitchen!
    
    //MARK: - Outlets
    
    @IBOutlet var firstNameTextField: UITextField!
    @IBOutlet var lastNameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    //MARK: - Dependency Injection
    
    func inject(kitchen: RegisterKitchen) {
        self.kitchen = kitchen
    }
    
    //MARK: - View Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }
    
    //MARK: - Actions
    
    @IBAction func didTapRegister() {
        guard let firstName = firstNameTextField.text, !firstName.isEmpty else {
            SVProgressHUD.showError(withStatus: NSLocalizedString("Enter First Name", comment: ""))
            return
        }
        guard let lastName = lastNameTextField.text, !lastName.isEmpty else {
            SVProgressHUD.showError(withStatus: NSLocalizedString("Enter Last Name", comment: ""))
            return
        }
        guard let email = emailTextField.text, !email.isEmpty else {
            SVProgressHUD.showError(withStatus: NSLocalizedString("Enter email", comment: ""))
            return
        }
        guard email.isValidEmail() else {
            SVProgressHUD.showError(withStatus: NSLocalizedString("Enter valid email", comment: ""))
            return
        }
        guard let password = passwordTextField.text, !password.isEmpty else {
            SVProgressHUD.showError(withStatus: NSLocalizedString("Enter password", comment: ""))
            return
        }
        
        kitchen.receive(event: .didTapRegister(firstName: firstName, lastName: lastName, email: email, password: password))
    }
    
    @IBAction func didTapCallForAssistance() {
       PhoneCaller.call()
    }
}

//MARK: - Kitchen Delegate

extension RegisterViewController: KitchenDelegate {
    typealias Command = RegisterState
    
    func perform(_ command: Command) {
        switch command {
        case .startLoading:
            SVProgressHUD.show()
        case .finishLoading:
            SVProgressHUD.dismiss()
        case .registered(let message):
            SVProgressHUD.showSuccess(withStatus: message)
            navigationController?.popViewController(animated: true)
        case .errorHappend(let error):
            SVProgressHUD.showError(withStatus: error)
        }
    }
}

// MARK: - Blue Navigation Bar

extension RegisterViewController: BlueNavigationBar {
    
}
