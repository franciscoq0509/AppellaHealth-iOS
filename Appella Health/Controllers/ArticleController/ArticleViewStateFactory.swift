//
//  ArticleViewStateFactory.swift
//  Appella Health
//
//  Created by F.Q. on 01.04.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation

class ArticleViewStateFactory {
    
    private let articleConverter: ArticleConverter
    
    init(articleConverter: ArticleConverter) {
        self.articleConverter = articleConverter
    }
    
    func make(_ article: Article, _ articles: [Article]) -> ArticleViewState{
        let convertedArticle = articleConverter.convert(article: article)
        let convertedArticles = articles.map { article -> ArticleViewModel in
            return articleConverter.convert(article: article)
        }
        
        let more = NSLocalizedString("MORE", comment: "")
        let news = NSLocalizedString("NEWS", comment: "")
        var moreNews: String
        var canShowPhotos = false
        if let category = ArticleCategory(rawValue: article.categoryId) {
            switch category {
            case .news:
                moreNews = "\(more) \(news)"
            default:
                moreNews = "\(more) \(category.describing.uppercased()) \(news)"
            }
            if category == .photoGallery, article.photos.count > 0 {
                canShowPhotos = true
            }
        }
        else {
            moreNews = "\(more) \(news)"
        }
        return ArticleViewState(article: convertedArticle, articles: convertedArticles, moreNewsTitle: moreNews, canShowPhotos: canShowPhotos)
    }
    
    
}
