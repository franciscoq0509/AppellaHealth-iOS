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
import OneSignal

class AppDelegate: UIResponder, UIApplicationDelegate {
    
    private enum Consts {
        static let oneSignalAppId = "ef094d29-eaaa-45e0-819f-7a5adfb69c78"
    }

    var window: UIWindow?
    let assembler: Assembler

    init(assembler: Assembler) {
        self.assembler = assembler
        super.init()
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //Setup appearance
        
        application.isStatusBarHidden = true
        
        //Setup extensions
        
        IQKeyboardManager.shared().isEnabled = true
        let onesignalInitSettings = [kOSSettingsKeyAutoPrompt: false]
        OneSignal.initWithLaunchOptions(launchOptions,
                                        appId: Consts.oneSignalAppId,
                                        handleNotificationAction: nil,
                                        settings: onesignalInitSettings)
        OneSignal.inFocusDisplayType = OSNotificationDisplayType.notification;
        OneSignal.promptForPushNotifications(userResponse: { accepted in
            print("User accepted notifications: \(accepted)")
        })
        
        //Show login view or news view
        
        var storyboard: UIStoryboard
        if UserDefaults.getApiKey() != nil {
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

