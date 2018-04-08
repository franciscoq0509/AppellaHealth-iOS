//
//  Article.swift
//  Appella Health
//
//  Created by F.Q. on 28.03.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation

struct ArticlesResponse: Codable {
    let status: ResponseStatus
    let articles: [Article]
    
    enum CodingKeys: String, CodingKey {
        case status
        case articles = "payload"
    }
}

struct ArticleResponse: Codable {
    let status: ResponseStatus
    let article: Article
    
    enum CodingKeys: String, CodingKey {
        case status
        case article = "payload"
    }
}

enum ArticleType: String, Codable {
    case image
    case video
}

struct Article: Codable {
    let articleId: Int
    let categoryId: Int
    let title: String
    let description: String
    let startDate: String?
    let endDate: String?
    let type: ArticleType?
    let thumbnailImage: String?
    let video: String?
    let photos: [Photo]
    
    enum CodingKeys: String, CodingKey {
        case articleId = "news_id"
        case categoryId = "category_id"
        case title
        case description
        case startDate = "start_date"
        case endDate = "end_date"
        case type
        case thumbnailImage = "thumbnail_image"
        case video
        case photos
    }
}

struct Photo: Codable {
    let image: String
}
