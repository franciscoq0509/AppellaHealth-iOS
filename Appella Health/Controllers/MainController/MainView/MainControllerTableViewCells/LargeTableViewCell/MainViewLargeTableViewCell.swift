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
    
    private var gradientLayer: CAGradientLayer?
    
    //MARK: - Outlets
    
    @IBOutlet private var mainImage: UIImageView!
    @IBOutlet private var playIcon: UIImageView!
    @IBOutlet private var title: UILabel!
    @IBOutlet private var gradientView: UIView!
    @IBOutlet private var bottomSpacing: NSLayoutConstraint!
    
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
        switch article.imageType {
        case .full:
            bottomSpacing.constant = 0
        case .half:
            bottomSpacing.constant = 1
        }
        setupGradient()
    }
    
    //MARK: - Helpers
    
    func setupGradient() {
        layoutIfNeeded()
        
        if gradientLayer == nil {
            let gradientLayer = CAGradientLayer()
            gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
            gradientView.layer.insertSublayer(gradientLayer, at: 0)
            self.gradientLayer = gradientLayer
        }
        gradientLayer?.frame = gradientView.bounds
    }
    
}
