//
//  ArticleViewModel.swift
//  Appella Health
//
//  Created by F.Q. on 30.03.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation

struct ArticleViewModel {
    let title: String
    let imageUrl: String?
    let date: String?
    let showVideoButton: Bool
    let description: String
    let id: Int
    let video: String?
    let photoUrls: [String]
    let imageType: ImageType
}
