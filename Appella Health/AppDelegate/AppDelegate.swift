//
//  AppDelegate.swift
//  Appella Health
//
//  Created by F.Q. on 26.03.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import Swinject
import IQKeyboardManager

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let assembler: Assembler

    init(assembler: Assembler) {
        self.assembler = assembler
        super.init()
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        IQKeyboardManager.shared().isEnabled = true
        
        var storyboard: UIStoryboard
        if UserDefaults.getUserId() != nil {
            storyboard = UIStoryboard.main
        }
        else {
            storyboard = UIStoryboard.login
        }
        guard let viewController = storyboard.instantiateInitialViewController() else {
            fatalError("failed to load storyboard's initial view controller")
        }
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
        
        return true
    }
}

