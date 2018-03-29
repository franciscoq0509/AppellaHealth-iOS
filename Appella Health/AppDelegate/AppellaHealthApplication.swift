//
//  AppellaHealthApplication.swift
//  Appella Health
//
//  Created by F.Q. on 26.03.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation
import UIKit
import Swinject
import SwinjectStoryboard

class AppellaHealthApplication: UIApplication {
    
    static var assembler: Assembler!
    var strongDelegate: UIApplicationDelegate?
    
    override init() {
        super.init()
        
        AppellaHealthApplication.assembler = Assembler([MainAssembly()], container: SwinjectStoryboard.defaultContainer)
        Container.loggingFunction = nil
        
        strongDelegate = AppDelegate(assembler: AppellaHealthApplication.assembler)
        delegate = strongDelegate
    }
}
