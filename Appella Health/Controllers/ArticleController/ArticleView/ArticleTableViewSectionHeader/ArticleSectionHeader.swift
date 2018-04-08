//
//  ArticleSectionHeader.swift
//  Appella Health
//
//  Created by F.Q. on 01.04.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class ArticleSectionHeader: UITableViewCell {
    
    static let identifier = "ArticleSectionHeader"
    
    @IBOutlet private var title: UILabel!
    
    func configureWith(text: String) {
        title.text = text
    }
}
