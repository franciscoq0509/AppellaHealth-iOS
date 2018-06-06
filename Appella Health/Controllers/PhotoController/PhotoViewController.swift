//
//  PhotoViewController.swift
//  Appella Health
//
//  Created by F.Q. on 02.04.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController {
    
    //MARK: - Properties
    
    var image: UIImage?
    
    //MARK: - Outlets
    
    @IBOutlet private var photo: UIImageView!
    
    //MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photo.image = image
        addTextToRightBarItem(text: NSLocalizedString("Appella Health", comment: ""))
    }
    
    //MARK: - Actions
    
    @IBAction private func didTapShareButton(_ sender: UIButton) {
        guard let image = image else {
            return
        }
        let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = sender
        self.present(activityViewController, animated: true, completion: nil)
    }
}

//MARK: Add Label To Right Bar Item

extension PhotoViewController: AddLabelToRightBarItem {
    
}
