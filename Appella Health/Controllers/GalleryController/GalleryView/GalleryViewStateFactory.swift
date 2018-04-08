//
//  GalleryViewStateFactory.swift
//  Appella Health
//
//  Created by F.Q. on 02.04.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation

class GalleryViewStateFactory {
    func make(photos: [String]) -> GalleryViewState {
        return GalleryViewState(photos: photos)
    }
}
