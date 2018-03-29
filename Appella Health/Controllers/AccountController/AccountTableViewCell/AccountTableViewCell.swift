//
//  AccountTableViewCell.swift
//  Appella Health
//
//  Created by F.Q. on 28.03.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

typealias SwitchChanged = (Bool) -> ()

class AccountTableViewCell: UITableViewCell {
    
    static let identifier = "AccountTableViewCell"
    
    var switchChanged: SwitchChanged?
    
    @IBOutlet private var title: UILabel!
    @IBOutlet private var switchView: UISwitch!
    
    func setupCell(title: String, switchChangedCompletion: SwitchChanged? = nil) {
        self.title.text = title
        guard let switchChangedCompletion = switchChangedCompletion else {
            return
        }
        switchView.isHidden = false
        switchChanged = switchChangedCompletion
    }
    
    func changeSwitch(value: Bool) {
        switchView.isOn = value
    }
    
    @IBAction func switchValueChanged(_ sender: UISwitch) {
        switchChanged?(sender.isOn)
    }
    
}
