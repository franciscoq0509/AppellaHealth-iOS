//
//  MainAssembly.swift
//  Appella Health
//
//  Created by F.Q. on 26.03.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import Swinject
import SideMenu

class MainAssembly: Assembly {
    
    private var mainKitchen: MainKitchen!
    
    func assemble(container: Container) {
        
        //MARK: - Network Manager
        
        container.register(NetworkManager.self) { _ in
            return AlamofireNetworkManager()
        }
        
        //MARK: - Login
        
        container.register(LoginKitchen.self) { resolver in
            let networkManager = resolver.forceResolve(NetworkManager.self)
            return LoginKitchen(networkManager: networkManager)
        }
        container.storyboardInitCompleted(LoginViewController.self) { resolver, controller in
            let loginKitchen = resolver.forceResolve(LoginKitchen.self)
            controller.inject(kitchen: loginKitchen)
            loginKitchen.delegate = AnyKitchenDelegate(controller)
        }
        
        //MARK: - Register
        
        container.register(RegisterKitchen.self) { resolver in
            let networkManager = resolver.forceResolve(NetworkManager.self)
            return RegisterKitchen(networkManager: networkManager)
        }
        container.storyboardInitCompleted(RegisterViewController.self) { resolver, controller in
            let registerKitchen = resolver.forceResolve(RegisterKitchen.self)
            controller.inject(kitchen: registerKitchen)
            registerKitchen.delegate = AnyKitchenDelegate(controller)
        }
        
        //MARK: - Forgot Password
        
        container.register(ForgotPasswordKitchen.self) { resolver in
            let networkManager = resolver.forceResolve(NetworkManager.self)
            return ForgotPasswordKitchen(networkManager: networkManager)
        }
        container.storyboardInitCompleted(ForgotPasswordViewController.self) { resolver, controller in
            let forgotPasswordKitchen = resolver.forceResolve(ForgotPasswordKitchen.self)
            controller.inject(kitchen: forgotPasswordKitchen)
            forgotPasswordKitchen.delegate = AnyKitchenDelegate(controller)
        }
        
        //MARK: - Main
        
        container.register(MainKitchen.self) { resolver in
            if self.mainKitchen == nil {
                self.mainKitchen = MainKitchen()
            }
            return self.mainKitchen
        }
        container.storyboardInitCompleted(MainViewController.self) { resolver, controller in
            let mainKitchen = resolver.forceResolve(MainKitchen.self)
            controller.inject(kitchen: mainKitchen)
            self.mainKitchen.delegate = AnyKitchenDelegate(controller)
        }
        
        //MARK: - Side Menu
        
        container.register(SideMenuKitchen.self) { resolver in
            let mainKitchen = resolver.forceResolve(MainKitchen.self)
            return SideMenuKitchen(mainKitchenDelegate: mainKitchen)
        }
        container.storyboardInitCompleted(SideMenuViewController.self) { resolver, controller in
            let sideMenuKitchen = resolver.forceResolve(SideMenuKitchen.self)
            controller.inject(kitchen: sideMenuKitchen)
            sideMenuKitchen.delegate = AnyKitchenDelegate(controller)
        }
        
        //MARK: - Account
        
        container.register(AccountKitchen.self) { resolver in
            let networkManager = resolver.forceResolve(NetworkManager.self)
            return AccountKitchen(networkManager: networkManager)
        }
        container.storyboardInitCompleted(AccountViewController.self) { resolver, controller in
            
            let accountKitchen = resolver.forceResolve(AccountKitchen.self)
            controller.inject(kitchen: accountKitchen)
            accountKitchen.delegate = AnyKitchenDelegate(controller)
        }
        
        //MARK: - Privacy Policy
        
        container.register(PrivacyPolicyKitchen.self) { resolver in
            let networkManager = resolver.forceResolve(NetworkManager.self)
            return PrivacyPolicyKitchen(networkManager: networkManager)
        }
        container.storyboardInitCompleted(PrivacyPolicyViewController.self) { resolver, controller in
            let privacyPolicyKitchen = resolver.forceResolve(PrivacyPolicyKitchen.self)
            controller.inject(kitchen: privacyPolicyKitchen)
            privacyPolicyKitchen.delegate = AnyKitchenDelegate(controller)
        }
    }
}
