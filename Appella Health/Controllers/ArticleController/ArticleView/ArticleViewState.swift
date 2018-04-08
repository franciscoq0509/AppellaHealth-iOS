//
//  ArticleViewState.swift
//  Appella Health
//
//  Created by F.Q. on 01.04.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation

struct ArticleViewState {
    private(set) var article: ArticleViewModel
    private(set) var articles: [ArticleViewModel]
    private(set) var moreNewsTitle: String
    private(set) var canShowPhotos: Bool
    
    init(article: ArticleViewModel, articles: [ArticleViewModel], moreNewsTitle: String, canShowPhotos: Bool) {
        self.article = article
        self.articles = articles
        self.moreNewsTitle = moreNewsTitle
        self.canShowPhotos = canShowPhotos
    }
}
