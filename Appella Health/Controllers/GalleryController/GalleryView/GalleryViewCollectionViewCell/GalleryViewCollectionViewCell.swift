//
//  GalleryViewCollectionViewCell.swift
//  Appella Health
//
//  Created by F.Q. on 02.04.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import SDWebImage

class GalleryViewCollectionViewCell: UICollectionViewCell {

    static let identifier = "GalleryViewCollectionViewCell"
    
    @IBOutlet private var image: UIImageView!
    
    func configureWith(url: String) {
        image.sd_setImage(with: URL(string: url))
    }

    func getImage() -> UIImage? {
        return image.image
    }
}
