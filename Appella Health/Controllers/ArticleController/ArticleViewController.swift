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
    func nextArticle()
    func previousArticle()
}

class ArticleViewController: BaseViewController {

    //MARK: - Properties
    
    private var kitchen: ArticleKitchen?
    private var articleId: Int? {
        didSet {
            guard let articleId = articleId else {
                return
            }
            kitchen?.receive(event: .initWithArticle(id: articleId))
        }
    }
    private var articlesCategory: ArticleCategory? {
        didSet {
            guard let articlesCategory = articlesCategory else {
                return
            }
            kitchen?.receive(event: .setupArticlesCategory(articlesCategory))
        }
    }
    
    //MARK: - Outlets
    
    @IBOutlet private var articleView: ArticleView! {
        didSet {
            articleView.articleViewControllerDelegate = self
            articleView.setupGestureRecognizers()
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
        articleView.frame = view.bounds
    }
    
    //MARK: - Helpers
    
    func setup(articleId: Int, articlesCategory: ArticleCategory) {
        self.articlesCategory = articlesCategory
        self.articleId = articleId
    }
    
    func didLoadOtherArticle(_ viewState: ArticleViewState, direction: ArticleSwitch) {
        var otherViewFrame = articleView.frame
        switch direction {
        case .next:
            otherViewFrame.origin.x += articleView.frame.width
        case .previous:
            otherViewFrame.origin.x -= articleView.frame.width
        }
        
        let otherView = ArticleView(frame: otherViewFrame)
        otherView.configureWith(viewState: viewState)
        view.addSubview(otherView)
        
        UIView.animate(withDuration: 0.5, animations: {
            otherView.frame = self.articleView.frame
            switch direction {
            case .next:
                self.articleView.frame.origin.x -= self.articleView.frame.width
            case .previous:
                self.articleView.frame.origin.x += self.articleView.frame.width
            }
        }) { _ in
            self.articleView.removeFromSuperview()
            self.articleView = otherView
            self.kitchen?.receive(event: .refreshData)
        }
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
            self.navigationController?.popViewController(animated: true)
        case .dataLoaded(let viewState):
            articleView.configureWith(viewState: viewState)
        case .logout:
            Logout.perform()
        case .didLoadNextArticle(let viewState):
            didLoadOtherArticle(viewState, direction: .next)
        case .didLoadPreviousArticle(let viewState):
            didLoadOtherArticle(viewState, direction: .previous)
        }
    }
}

//MARK: - Article View Controller Delegate

extension ArticleViewController: ArticleViewControllerDelegate {
    func didSelectArticleWith(id: Int) {
        kitchen?.receive(event: .didSelectArticleWith(id: id))
    }
    
    func playVideo(url: String?) {
        guard let url = url, let videoUrl = URL(string: url) else {
            return
        }
        let avPlayer = AVPlayer(url: videoUrl)
        avPlayer.play()
        let avPlayerController = VideoPlayerViewController()
        avPlayerController.player = avPlayer
        navigationController?.present(avPlayerController, animated: true, completion: nil)
        kitchen?.receive(event: .didOpenVideo)
    }
    
    func show(photos: [String]) {
        let storyboard = UIStoryboard.gallery
        guard let viewController = storyboard.instantiateInitialViewController() as? GalleryViewController else {
            fatalError("unexpected view controller")
        }
        viewController.photos = photos
        navigationController?.show(viewController, sender: self)
        kitchen?.receive(event: .didOpenGalleryView)
    }
    
    func nextArticle() {
        self.kitchen?.receive(event: .didSwipeToNextArticle)
    }
    
    func previousArticle() {
        self.kitchen?.receive(event: .didSwipeToPreviousArticle)
    }
}

//MARK: Add Label To Right Bar Item

extension ArticleViewController: AddLabelToRightBarItem {
    
}

//MARK: - Remove Back Button Title

extension ArticleViewController: RemoveBackButtonTitle {
    
}
