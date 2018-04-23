//
//  PrivacyPolicyViewController.swift
//  Appella Health
//
//  Created by F.Q. on 28.03.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import SVProgressHUD

class PrivacyPolicyViewController: BaseViewController {

    //MARK: - Properties
    
    var kitchen: PrivacyPolicyKitchen!
    
    //MARK: - Outlets
    
    @IBOutlet private var textView: UITextView!
    
    //MARK: - Dependency Injection
    
    func inject(kitchen: PrivacyPolicyKitchen) {
        self.kitchen = kitchen
    }
    
    //MARK: - View Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        kitchen.receive(event: .viewWillAppear)
    }
    
    //MARK: - Setup
    
    func setupTextViewWith(_ text: String) {
        if let attributedString = text.stringFromHtml() {
            textView.attributedText = attributedString
        }
        else {
            textView.text = text
        }
    }
}

//MARK: - Kitchen Delegate

extension PrivacyPolicyViewController: KitchenDelegate {
    typealias Command = PrivacyPolicyState
    
    func perform(_ command: PrivacyPolicyState) {
        switch command {
        case .startLoading:
            SVProgressHUD.show()
        case .finishLoading:
            SVProgressHUD.dismiss()
        case .errorHappend(let error):
            SVProgressHUD.showError(withStatus: error)
            navigationController?.popViewController(animated: true)
        case .textLoaded(let text):
            setupTextViewWith(text)
        case .logout:
            Logout.perform()
        }
    }
}
