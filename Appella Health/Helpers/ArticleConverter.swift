//
//  ArticleConverter.swift
//  Appella Health
//
//  Created by F.Q. on 03.04.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation

class ArticleConverter {
    func convert(article: Article) -> ArticleViewModel {
        let convertedDate = AppellaHealthDateFormatter().convert(article.publishDate)
        let photoUrls = article.photos.map { photo -> String in
            return photo.image
        }
        let showVideoButton = article.type == .video ? true : false
        let convertedArticle = ArticleViewModel(title: article.title, imageUrl: article.thumbnailImage, date: convertedDate, showVideoButton: showVideoButton, description: article.description, id: article.articleId, video: article.video, photoUrls: photoUrls, imageType: article.imageType)
        return convertedArticle
    }
}
