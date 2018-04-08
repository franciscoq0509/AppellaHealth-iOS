//
//  GalleryKitchen.swift
//  Appella Health
//
//  Created by F.Q. on 02.04.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation

enum GalleryViewEvent {
    case load(photos: [String])
}

enum GalleryState {
    case didLoad(viewState: GalleryViewState)
}

class GalleryKitchen: Kitchen {
    typealias ViewEvent = GalleryViewEvent
    typealias Command = GalleryState
    
    var delegate: AnyKitchenDelegate<GalleryState>?
    var galleryViewStateFactory: GalleryViewStateFactory
    
    init(galleryViewStateFactory: GalleryViewStateFactory) {
        self.galleryViewStateFactory = galleryViewStateFactory
    }
    
    func receive(event: GalleryViewEvent) {
        switch event {
        case .load(let photos):
            delegate?.perform(.didLoad(viewState: galleryViewStateFactory.make(photos: photos)))
        }
    }
}
