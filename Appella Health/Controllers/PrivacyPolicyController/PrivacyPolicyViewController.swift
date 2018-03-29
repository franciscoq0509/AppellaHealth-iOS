//
//  PrivacyPolicyViewController.swift
//  Appella Health
//
//  Created by F.Q. on 28.03.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import SVProgressHUD
import WebKit

class PrivacyPolicyViewController: BaseViewController {

    //MARK: - Properties
    
    var kitchen: PrivacyPolicyKitchen!
    
    //MARK: - Outlets
    
    @IBOutlet private var webView: WKWebView!
    
    //MARK: - Dependency Injection
    
    func inject(kitchen: PrivacyPolicyKitchen) {
        self.kitchen = kitchen
    }
    
    //MARK: - View Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        kitchen.receive(event: .viewWillAppear)
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
            webView.loadHTMLString(text, baseURL: nil)
        }
    }
}
