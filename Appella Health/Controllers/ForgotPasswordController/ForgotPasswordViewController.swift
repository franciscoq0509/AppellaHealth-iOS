//
//  ForgotPasswordViewController.swift
//  Appella Health
//
//  Created by F.Q. on 27.03.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import SVProgressHUD

class ForgotPasswordViewController: BaseViewController {
    
    //MARK: - Properties
    
    var kitchen: ForgotPasswordKitchen!
    
    //MARK: - Outlets
    
    @IBOutlet var emailTextField: UITextField!
    
    //MARK: - Dependency Injection
    
    func inject(kitchen: ForgotPasswordKitchen) {
        self.kitchen = kitchen
    }
    
    //MARK: - View Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupNavigationBar()
    }
    
    //MARK: - Actions
    
    @IBAction func didTapSubmit() {
        guard let email = emailTextField.text, !email.isEmpty else {
            SVProgressHUD.showError(withStatus: NSLocalizedString("Enter email", comment: ""))
            return
        }
        guard email.isValidEmail() else {
            SVProgressHUD.showError(withStatus: NSLocalizedString("Enter valid email", comment: ""))
            return
        }
        kitchen.receive(event: .didTapSubmit(email: email))
    }
}

//MARK: - Kitchen Delegate

extension ForgotPasswordViewController: KitchenDelegate {
    typealias Command = ForgotPasswordState
    
    func perform(_ command: Command) {
        switch command {
        case .startLoading:
            SVProgressHUD.show()
        case .finishLoading:
            SVProgressHUD.dismiss()
        case .loaded(let message):
            SVProgressHUD.showSuccess(withStatus: message)
            navigationController?.popViewController(animated: true)
        case .errorHappend(let error):
            SVProgressHUD.showError(withStatus: error)
        }
    }
}

//MARK: - Blue Navigation Bar

extension ForgotPasswordViewController: BlueNavigationBar {
    
}
