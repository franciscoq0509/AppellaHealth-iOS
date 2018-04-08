//
//  MainViewStateFactory.swift
//  Appella Health
//
//  Created by F.Q. on 30.03.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation

class MainViewStateFactory {
    
    private let articleConverter: ArticleConverter
    
    init(articleConverter: ArticleConverter) {
        self.articleConverter = articleConverter
    }
    
    func make(_ articles: [Article]) -> MainViewState {
        let articlesViewModel = articles.map { article -> ArticleViewModel in
            return articleConverter.convert(article: article)
        }
        return MainViewState(articles: articlesViewModel)
    }
}
