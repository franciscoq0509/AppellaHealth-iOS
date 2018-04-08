//
//  GalleryViewController.swift
//  Appella Health
//
//  Created by F.Q. on 02.04.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

protocol GalleryViewControllerDelegate: class {
    func didSelect(image: UIImage)
}

class GalleryViewController: BaseViewController {
    
    //MARK: - Properties
    
    private var kitchen: GalleryKitchen!
    var photos: [String]?

    //MARK: - Outlets
    
    @IBOutlet private var galleryView: GalleryView! {
        didSet {
            galleryView.delegate = self
        }
    }
    
    //MARK: - Dependency Injection
    
    func inject(kitchen: GalleryKitchen) {
        self.kitchen = kitchen
    }

    //MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        removeBackButtonTitle()
        addTextToRightBarItem(text: NSLocalizedString("Appella Health", comment: ""))
        
        guard let photos = photos else {
            return
        }
        kitchen.receive(event: .load(photos: photos))
    }
}

//MARK: - Kitchen Delegate

extension GalleryViewController: KitchenDelegate {
    typealias Command = GalleryState
    
    func perform(_ command: GalleryState) {
        switch command {
        case .didLoad(let viewState):
            galleryView.configureWith(viewState: viewState)
        }
    }
}

//MARK: - Gallery View Controller Delegate

extension GalleryViewController: GalleryViewControllerDelegate {
    func didSelect(image: UIImage) {
        let storyboard = UIStoryboard.photo
        guard let viewController = storyboard.instantiateInitialViewController() as? PhotoViewController else {
            fatalError("Unexpected view controller")
        }
        viewController.image = image
        navigationController?.show(viewController, sender: self)
    }
}

//MARK: Add Label To Right Bar Item

extension GalleryViewController: AddLabelToRightBarItem {
    
}

//MARK: - Remove Back Button Title

extension GalleryViewController: RemoveBackButtonTitle {
    
}
