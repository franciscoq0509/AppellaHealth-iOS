//
//  HelpDeskViewController.swift
//  Appella Health
//
//  Created by F.Q. on 28.03.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import SideMenu

class HelpDeskViewController: UIViewController {
    
    //MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addTextToRightBarItem(text: NSLocalizedString("Appella Health", comment: ""))
        setMenuIcon(#selector(didTapMenuButton))
    }
    
    //MARK: - Actions
    
    @IBAction func didTapCallButton() {
        PhoneCaller.call()
    }
    
    @objc func didTapMenuButton() {
        showMenu()
    }
}

//MARK: - Add Label To Right Bar Item

extension HelpDeskViewController: AddLabelToRightBarItem {
    
}

//MARK: - MenuIcon

extension HelpDeskViewController: MenuIcon {
    
}
