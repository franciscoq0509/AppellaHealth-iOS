//
//  ArticleKitchen.swift
//  Appella Health
//
//  Created by F.Q. on 01.04.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation

enum ArticleViewEvent {
    case initWithArticle(id: Int)
    case didSwipeToNextArticle
    case didSwipeToPreviousArticle
    case setupArticlesCategory(ArticleCategory)
    case refreshData
    case didSelectArticleWith(id: Int)
    case didOpenVideo
    case didOpenGalleryView
}

enum ArticleState {
    case startLoading
    case finishLoading
    case errorHappend(error: String)
    case dataLoaded(viewState: ArticleViewState)
    case logout
    case didLoadNextArticle(viewState: ArticleViewState)
    case didLoadPreviousArticle(viewState: ArticleViewState)
}

enum ArticleSwitch {
    case previous
    case next
}

class ArticleKitchen: Kitchen {
    typealias ViewEvent = ArticleViewEvent
    typealias Command = ArticleState
    
    var delegate: AnyKitchenDelegate<ArticleState>?
    let networkManager: NetworkManager
    let articleViewStateFactory: ArticleViewStateFactory
    var articleStateVariables: ArticleStateVariables
    
    init(networkManager: NetworkManager, articleViewStateFactory: ArticleViewStateFactory, articleStateVariables: ArticleStateVariables) {
        self.networkManager = networkManager
        self.articleViewStateFactory = articleViewStateFactory
        self.articleStateVariables = articleStateVariables
    }
    
    func receive(event: ArticleViewEvent) {
        switch event {
        case .initWithArticle(let id):
            articleStateVariables.setCurrentArticleId(id)
            loadArticle()
        case .didSwipeToNextArticle:
            otherArticle(type: .next)
        case .didSwipeToPreviousArticle:
            otherArticle(type: .previous)
        case .setupArticlesCategory(let category):
            articleStateVariables.setArticlesCategory(category)
        case .refreshData:
            loadArticle()
        case .didSelectArticleWith(id: let id):
            if let viewState = getViewStateForArticleWith(id: id) {
                delegate?.perform(.didLoadNextArticle(viewState: viewState))
            }
        case .didOpenGalleryView:
            recordDeepView()
        case .didOpenVideo:
            recordDeepView()
        }
    }
    
    private func loadArticle() {
        guard let articleId = articleStateVariables.currentArticleId else {
            return
        }
        delegate?.perform(.startLoading)
        networkManager.getArticle(articleId: articleId).onSuccess { [weak self] article in
            guard let _self = self else {
                return
            }
            guard let articleCategory = _self.articleStateVariables.articlesCategory else {
                fatalError("expected article category")
            }
            _self.networkManager.getArticles(category: articleCategory).onSuccess { [weak self] articles in
                guard let _self = self else {
                    return
                }
                _self.delegate?.perform(.finishLoading)
                
                if let currentArticleId = _self.articleStateVariables.currentArticleId,
                    currentArticleId != article.articleId {
                    return
                }
                
                _self.articleStateVariables.setArticles(articles)
                
                if let viewState = _self.getViewStateForArticleWith(id: article.articleId) {
                    _self.delegate?.perform(.dataLoaded(viewState: viewState))
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
    
    private func getViewStateForArticleWith(id: Int) -> ArticleViewState? {
        guard let articles = articleStateVariables.articles,
            let articleIndex = articles.index(where: {$0.articleId == id}) else {
                return nil
        }
        let article = articles[articleIndex]
        
        articleStateVariables.setCurrentArticleId(article.articleId)
        let nextArticles = getArticles(after: articleIndex)
        guard let articlesCategory = articleStateVariables.articlesCategory else {
            fatalError("Expected articles category")
        }
        let viewState = articleViewStateFactory.make(article, nextArticles, category: articlesCategory)
        
        return viewState
    }
    
    private func otherArticle(type: ArticleSwitch) {
        guard  let currentArticleId = articleStateVariables.currentArticleId,
            let articles = articleStateVariables.articles,
            let currentArticleIndex = articles.index(where: {$0.articleId == currentArticleId}) else {
            return
        }
        
        switch type {
        case .next:
            guard currentArticleIndex < articles.count - 1 else {
                return
            }
        case .previous:
            guard currentArticleIndex > articles.startIndex else {
                return
            }
        }
        
        let otherArticleIndex = type == .next ? articles.index(after: currentArticleIndex): articles.index(before: currentArticleIndex)
        let article = articles[otherArticleIndex]
        guard let viewState = getViewStateForArticleWith(id: article.articleId) else {
            return
        }
        
        switch type {
        case .next:
            delegate?.perform(.didLoadNextArticle(viewState: viewState))
        case .previous:
            delegate?.perform(.didLoadPreviousArticle(viewState: viewState))
        }
    }
    
    private func getArticles(after index: Int) -> [Article] {
        let _index = index + 1
        guard var articles = articleStateVariables.articles,
            index < articles.count else {
            return []
        }
        let nextArticles = articles[_index...]
        return Array(nextArticles)
    }
    
    private func recordDeepView() {
        guard let currentArticleId = articleStateVariables.currentArticleId else {
            return
        }
        networkManager.recordDeepView(articleId: currentArticleId).onFailure { [weak self] error in
            guard let _self = self else {
                return
            }
            if error.error is InvalidTokenError {
                _self.delegate?.perform(.logout)
            }
        }
    }
}
