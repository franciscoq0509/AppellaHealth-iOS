//
//  MainViewSmallTableViewCell.swift
//  Appella Health
//
//  Created by F.Q. on 28.03.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import SDWebImage

class MainViewSmallTableViewCell: UITableViewCell {
    
    static let identifier = "MainViewSmallTableViewCell"

    //MARK: - Outlets
    
    @IBOutlet private var mainImage: UIImageView!
    @IBOutlet private var title: UILabel!
    @IBOutlet private var date: UILabel!
    @IBOutlet private var videoIcon: UIImageView!
    
    func configure(with article: ArticleViewModel) {
        if let imageUrl = article.imageUrl {
            mainImage.sd_setImage(with: URL(string: imageUrl))
        }
        else {
            mainImage.image = nil
        }
        title.text = article.title
        date.text = article.date
        
        if article.showVideoButton {
            videoIcon.isHidden = false
        }
        else {
            videoIcon.isHidden = true
        }
    }
}
