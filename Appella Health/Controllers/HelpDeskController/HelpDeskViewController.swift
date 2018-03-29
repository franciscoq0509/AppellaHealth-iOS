//
//  HelpDeskViewController.swift
//  Appella Health
//
//  Created by F.Q. on 28.03.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class HelpDeskViewController: UIViewController {
    
    //MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addTextToRightBarItem(text: NSLocalizedString("Appella Health", comment: ""))
    }
    
    //MARK: - Actions
    
    @IBAction func didTapCallButton() {
        PhoneCaller.call()
    }
}

//MARK: - Add Label To Right Bar Item

extension HelpDeskViewController: AddLabelToRightBarItem {
    
}
