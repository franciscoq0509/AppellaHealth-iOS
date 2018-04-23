//
//  PhoneCaller.swift
//  Appella Health
//
//  Created by F.Q. on 28.03.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

enum PhoneCaller {
    
    enum Consts {
        static let phoneNumber = "301-229-1540"
    }
    
    static func call() {
        guard let url = URL(string: "tel://\(Consts.phoneNumber)"),
            UIApplication.shared.canOpenURL(url) else {
                return
        }
        UIApplication.shared.open(url)
    }
}
