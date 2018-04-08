//
//  GalleryView.swift
//  Appella Health
//
//  Created by F.Q. on 02.04.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class GalleryView: UIView {
    
    //MARK: - Properties
    
    var viewState: GalleryViewState! {
        didSet {
            collectionView.reloadData()
        }
    }
    weak var delegate: GalleryViewControllerDelegate?

    //MARK: - Outlets
    
    @IBOutlet private var collectionView: UICollectionView! {
        didSet {
            collectionView.dataSource = self
            collectionView.delegate = self
            let nib = UINib(nibName: GalleryViewCollectionViewCell.identifier, bundle: nil)
            collectionView.register(nib, forCellWithReuseIdentifier: GalleryViewCollectionViewCell.identifier)
        }
    }
    
    //MARK: - Configuration
    
    func configureWith(viewState: GalleryViewState) {
        self.viewState = viewState
    }

}

//MARK: - UICollectionView Data Source

extension GalleryView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let photosCount = viewState?.photos.count {
            return photosCount
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let photoUrl = viewState.photos[indexPath.row]
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GalleryViewCollectionViewCell.identifier, for: indexPath) as? GalleryViewCollectionViewCell else {
            fatalError("Unexpected collectionview cell")
        }
        cell.configureWith(url: photoUrl)
        return cell
    }
}

//MARK: - UICollectionView Delegate

extension GalleryView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? GalleryViewCollectionViewCell else {
            fatalError("Unexpected cell")
        }
        guard let image = cell.getImage() else {
            return
        }
        delegate?.didSelect(image: image)
    }
}

//MARK: - UICollectionView Delegate Flow Layout

extension GalleryView: UICollectionViewDelegateFlowLayout {
    
    private enum CollectionViewConsts {
        private static let offset: CGFloat = 2.5
        static let insetForSection = UIEdgeInsets(top: offset, left: offset, bottom: offset, right: offset)
        static let minimumInterItemsSpacing = offset
        static let minimumLineSpacing = offset
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (bounds.width - CollectionViewConsts.insetForSection.left - CollectionViewConsts.insetForSection.right - CollectionViewConsts.minimumInterItemsSpacing) / 2 
        let height = width
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return CollectionViewConsts.insetForSection
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CollectionViewConsts.minimumInterItemsSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CollectionViewConsts.minimumLineSpacing
    }
}
