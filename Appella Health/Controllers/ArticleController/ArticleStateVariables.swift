//
//  ArticleStateVariables.swift
//  Appella Health
//
//  Created by F.Q. on 11.04.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation

struct ArticleStateVariables {
    
    private(set) var currentArticleId: Int?
    private(set) var articles: [Article]?
    private(set) var articlesCategory: ArticleCategory?
    
    mutating func setCurrentArticleId(_ id: Int) {
        self.currentArticleId = id
    }
    
    mutating func setArticles(_ articles: [Article]) {
        self.articles = articles
    }
    
    mutating func setArticlesCategory(_ category: ArticleCategory) {
        articlesCategory = category
    }
}
