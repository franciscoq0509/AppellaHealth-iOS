//
//  ArticleKitchen.swift
//  Appella Health
//
//  Created by F.Q. on 01.04.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation

enum ArticleViewEvent {
    case didSelectArticleWith(id: Int)
}

enum ArticleState {
    case startLoading
    case finishLoading
    case errorHappend(error: String)
    case dataLoaded(viewState: ArticleViewState)
    case logout
}

class ArticleKitchen: Kitchen {
    typealias ViewEvent = ArticleViewEvent
    typealias Command = ArticleState
    
    var delegate: AnyKitchenDelegate<ArticleState>?
    let networkManager: NetworkManager
    let articleViewStateFactory: ArticleViewStateFactory
    
    init(networkManager: NetworkManager, articleViewStateFactory: ArticleViewStateFactory) {
        self.networkManager = networkManager
        self.articleViewStateFactory = articleViewStateFactory
    }
    
    func receive(event: ArticleViewEvent) {
        switch event {
        case .didSelectArticleWith(let id):
            loadArticle(id: id)
        }
    }
    
    private func loadArticle(id: Int) {
        delegate?.perform(.startLoading)
        networkManager.getArticle(articleId: id).onSuccess { [weak self] article in
            guard let _self = self else {
                return
            }
            guard let articleCategory = ArticleCategory(rawValue: article.categoryId) else {
                fatalError("unexpected article category")
            }
            _self.networkManager.getArticles(category: articleCategory).onSuccess { [weak self] articles in
                guard let _self = self else {
                    return
                }
                _self.delegate?.perform(.finishLoading)
                _self.delegate?.perform(.dataLoaded(viewState: _self.articleViewStateFactory.make(article, articles)))
            }.onFailure { [weak self] error in
                guard let _self = self else {
                    return
                }
                if error.error is InvalidTokenError {
                    _self.delegate?.perform(.logout)
                    return
                }
                _self.delegate?.perform(.finishLoading)
                _self.delegate?.perform(.errorHappend(error: error.message))
            }
        }.onFailure { [weak self] error in
            guard let _self = self else {
                return
            }
            if error.error is InvalidTokenError {
                _self.delegate?.perform(.logout)
                return
            }
            _self.delegate?.perform(.finishLoading)
            _self.delegate?.perform(.errorHappend(error: error.message))
        }
    }
}
