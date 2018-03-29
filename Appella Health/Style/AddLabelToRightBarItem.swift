//
//  AddLabelToRightBarItem.swift
//  Appella Health
//
//  Created by F.Q. on 28.03.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

protocol AddLabelToRightBarItem {
    var navigationItem: UINavigationItem {get}
    func addTextToRightBarItem(text: String, color: UIColor)
}

extension AddLabelToRightBarItem {
    func addTextToRightBarItem(text: String, color: UIColor = .white) {
        let titleLabel = UILabel()
        let barButtonItem = UIBarButtonItem()
        navigationItem.rightBarButtonItem = barButtonItem
        barButtonItem.customView = titleLabel
        titleLabel.text = text
        titleLabel.textColor = color
        titleLabel.sizeToFit()
    }
}
