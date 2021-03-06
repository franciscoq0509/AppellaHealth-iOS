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

enum ImageType: String, Codable {
    case full
    case half
    
    init(rawValue: String) {
        if (rawValue == "" || rawValue == "full") {
            self = .full
        }
        else {
            self = .half
        }
    }
}

struct Article: Codable {
    let articleId: Int
    let categoryId: Int
    let title: String
    let description: String
    let startDate: String?
    let endDate: String?
    let publishDate: String
    let type: ArticleType?
    let thumbnailImage: String?
    let video: String?
    let photos: [Photo]
    let imageType: ImageType
    
    enum CodingKeys: String, CodingKey {
        case articleId = "news_id"
        case categoryId = "category_id"
        case title
        case description
        case startDate = "start_date"
        case endDate = "end_date"
        case publishDate = "publish_date"
        case type
        case thumbnailImage = "thumbnail_image"
        case video
        case photos
        case imageType = "image_type"
    }
}

struct Photo: Codable {
    let image: String
}
