//
//  MainViewLargeTableViewCell.swift
//  Appella Health
//
//  Created by F.Q. on 28.03.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import SDWebImage

class MainViewLargeTableViewCell: UITableViewCell {
    
    static let identifier = "MainViewLargeTableViewCell"
    
    //MARK: - Properties
    
    private var gradientView: UIView?

    //MARK: - Outlets
    
    @IBOutlet private var mainImage: UIImageView!
    @IBOutlet private var playIcon: UIImageView!
    @IBOutlet private var title: UILabel!
    
    func configure(with article: ArticleViewModel) {
        if let imageUrl = article.imageUrl {
            mainImage.sd_setImage(with: URL(string: imageUrl))
        }
        else {
            mainImage.image = nil
        }
        title.text = article.title
        if article.showVideoButton {
            playIcon.isHidden = false
        }
        else {
            playIcon.isHidden = true
        }
        
        if gradientView == nil {
            setupGradient()
        }
    }
    
    //MARK: - Helpers
    
    func setupGradient() {
        layoutIfNeeded()
        let titleFrame = title.frame
        gradientView = UIView(frame: CGRect(x: self.frame.origin.x, y: titleFrame.origin.y, width: self.bounds.width, height: titleFrame.height))
        guard let gradientView = gradientView else {
            return
        }
        
        gradientView.alpha = 0.2
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.black.cgColor, UIColor.clear.cgColor]
        gradient.frame = gradientView.bounds
        gradient.startPoint = CGPoint(x: 0.5, y: 0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1)
        gradientView.layer.insertSublayer(gradient, at: 0)
        self.addSubview(gradientView)
        self.sendSubview(toBack: gradientView)
    }
    
}
