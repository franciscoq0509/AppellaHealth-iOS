//
//  ArticleViewController.swift
//  Appella Health
//
//  Created by F.Q. on 01.04.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import SVProgressHUD
import AVFoundation
import AVKit

protocol ArticleViewControllerDelegate: class {
    func didSelectArticleWith(id: Int)
    func playVideo(url: String?)
    func show(photos: [String])
}

class ArticleViewController: BaseViewController {

    //MARK: - Properties
    
    private var kitchen: ArticleKitchen?
    private var articleId: Int? {
        didSet {
            guard let articleId = articleId else {
                return
            }
            kitchen?.receive(event: .didSelectArticleWith(id: articleId))
        }
    }
    
    //MARK: - Outlets
    
    @IBOutlet private var articleView: ArticleView! {
        didSet {
            articleView.articleViewControllerDelegate = self
        }
    }
    
    //MARK: - Dependency Injection
    
    func inject(kitchen: ArticleKitchen) {
        self.kitchen = kitchen
    }
    
    //MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addTextToRightBarItem(text: NSLocalizedString("Appella Health", comment: ""))
        removeBackButtonTitle()
    }
    
    //MARK: - Helpers
    
    func setArticleId(_ articleId: Int) {
        self.articleId = articleId
    }
}

//MARK: - Kitchen Delegate {

extension ArticleViewController: KitchenDelegate {
    
    typealias Command = ArticleState
    func perform(_ command: Command) {
        switch command {
        case .startLoading:
            SVProgressHUD.show()
        case .finishLoading:
            SVProgressHUD.dismiss()
        case .errorHappend(let error):
            SVProgressHUD.showError(withStatus: error)
        case .dataLoaded(let viewState):
            articleView.configureWith(viewState: viewState)
        case .logout:
            Logout.perform()
        }
    }
}

//MARK: - Article View Controller Delegate

extension ArticleViewController: ArticleViewControllerDelegate {
    func didSelectArticleWith(id: Int) {
        let storyboard = UIStoryboard.article
        guard let viewController = storyboard.instantiateInitialViewController() as? ArticleViewController else {
            fatalError("Unexpected view controller")
        }
        viewController.setArticleId(id)
        navigationController?.show(viewController, sender: self)
    }
    
    func playVideo(url: String?) {
        guard let url = url, let videoUrl = URL(string: url) else {
            return
        }
        let avPlayer = AVPlayer(url: videoUrl)
        let avPlayerController = AVPlayerViewController()
        avPlayerController.player = avPlayer
        navigationController?.present(avPlayerController, animated: true, completion: nil)
    }
    
    func show(photos: [String]) {
        let storyboard = UIStoryboard.gallery
        guard let viewController = storyboard.instantiateInitialViewController() as? GalleryViewController else {
            fatalError("unexpected view controller")
        }
        viewController.photos = photos
        navigationController?.show(viewController, sender: self)
    }
}

//MARK: Add Label To Right Bar Item

extension ArticleViewController: AddLabelToRightBarItem {
    
}

//MARK: - Remove Back Button Title

extension ArticleViewController: RemoveBackButtonTitle {
    
}
