//
//  ArticleMainTableViewCell.swift
//  Appella Health
//
//  Created by F.Q. on 03.04.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import SDWebImage

class ArticleMainTableViewCell: UITableViewCell {
    
    static let identifier = "ArticleMainTableViewCell"
    
    private var imageTapGestureRecognizer: UITapGestureRecognizer?
    weak var delegate: ArticleViewDelegate?

    @IBOutlet private var mainImage: UIImageView!
    @IBOutlet private var title: UILabel!
    @IBOutlet private var descriptionLabel: UILabel!
    @IBOutlet private var videoButton: UIButton!
    @IBOutlet private var height: NSLayoutConstraint!
    
    func configure(with article: ArticleViewModel) {
        if let imageUrl = article.imageUrl {
            mainImage.sd_setImage(with: URL(string: imageUrl), completed: nil)
        }
        else {
            mainImage.image = nil
        }
        if imageTapGestureRecognizer == nil {
            let imageTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapImage))
            self.imageTapGestureRecognizer = imageTapGestureRecognizer
            mainImage.addGestureRecognizer(imageTapGestureRecognizer)
        }
        title.text = article.title
        
        if let attributedText = article.description.stringFromHtml() {
            descriptionLabel.attributedText = attributedText
        }
        else {
            descriptionLabel.text = article.description
        }
        
        if article.showVideoButton, article.video != nil {
            videoButton.isHidden = false
            height.constant = 256
        }
        else {
            videoButton.isHidden = true
            let deviceInfo = DeviceInfo()
            height.constant = deviceInfo == .iPhoneX ? 80: 60
        }
        layoutIfNeeded()
    }
    
    @IBAction private func didTapVideoButton() {
        delegate?.didTapPlayButton()
    }
    
    @objc private func didTapImage() {
        delegate?.didTapImage()
    }
}
