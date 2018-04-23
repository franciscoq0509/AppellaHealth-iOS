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
    
    func make(_ article: Article, _ articles: [Article], category: ArticleCategory) -> ArticleViewState{
        let convertedArticle = articleConverter.convert(article: article)
        let convertedArticles = articles.map { article -> ArticleViewModel in
            return articleConverter.convert(article: article)
        }
        
        let more = NSLocalizedString("MORE", comment: "")
        let news = NSLocalizedString("NEWS", comment: "")
        var moreNews: String
        
        let categoryDescribing = category.describing.uppercased()
        switch category {
        case .news:
            moreNews = "\(more) \(news)"
        case .events:
            moreNews = "\(more) \(categoryDescribing)"
            default:
            moreNews = "\(more) \(categoryDescribing) \(news)"
        }
        
        var canShowPhotos = false
        if let articleCategory = ArticleCategory(rawValue: article.categoryId),
            articleCategory == .photoGallery,
            article.photos.count > 0 {
            
            canShowPhotos = true
        }
        
        return ArticleViewState(article: convertedArticle, articles: convertedArticles, moreNewsTitle: moreNews, canShowPhotos: canShowPhotos)
    }
    
    
}
