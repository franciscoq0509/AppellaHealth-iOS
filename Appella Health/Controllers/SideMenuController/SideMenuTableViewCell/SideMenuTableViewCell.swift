//
//  SideMenuTableViewCell.swift
//  Appella Health
//
//  Created by F.Q. on 27.03.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class SideMenuTableViewCell: UITableViewCell {
    
    static let identifier = "SideMenuTableViewCell"

    @IBOutlet private var label: UILabel!
    @IBOutlet private var logoView: UIImageView!
    
    func setupCell(with text: String, imageViewIsHidden: Bool) {
        label.text = text
        logoView.isHidden = imageViewIsHidden 
    }
}
