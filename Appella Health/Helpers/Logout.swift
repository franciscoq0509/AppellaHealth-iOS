//
//  Logout.swift
//  Appella Health
//
//  Created by F.Q. on 06.04.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation
import UIKit

enum Logout {
    static func perform() {
        UserDefaults.setApiKey(nil)
        let storyboard = UIStoryboard.login
        guard let viewController = storyboard.instantiateInitialViewController() else {
            fatalError("failed to instantiate initial view controller of login storyboard")
        }
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("failed to unwrap AppDelegate")
        }
        appDelegate.window?.rootViewController = viewController
    }
}
