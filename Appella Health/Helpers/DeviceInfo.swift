//
//  DeviceInfo.swift
//  Appella Health
//
//  Created by F.Q. on 08.04.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation
import UIKit

enum DeviceInfo {
    case iPhoneX
    case unknown
    
    init() {
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 2436:
                self = .iPhoneX
            default:
                self = .unknown
            }
        }
        else {
            self = .unknown
        }
    }
}
