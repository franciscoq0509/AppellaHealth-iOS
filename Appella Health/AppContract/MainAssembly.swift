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
        
        container.register(ErrorHandler.self) { _ in
            return ErrorHandler()
        }
        
        container.register(NetworkManager.self) { resolver in
            let errorHandler = resolver.forceResolve(ErrorHandler.self)
            return AlamofireNetworkManager(errorHandler: errorHandler)
        }
        
        //MARK: - Helpers
        
        container.register(ArticleConverter.self) { _ in
            return ArticleConverter()
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
        
        container.register(MainViewStateFactory.self) { resolver in
            let articleConverter = resolver.forceResolve(ArticleConverter.self)
            return MainViewStateFactory(articleConverter: articleConverter)
        }
        container.register(MainKitchen.self) { resolver in
            if self.mainKitchen == nil {
                let networkManager = resolver.forceResolve(NetworkManager.self)
                let mainViewStateFactory = resolver.forceResolve(MainViewStateFactory.self)
                self.mainKitchen = MainKitchen(networkManager: networkManager, mainViewStateFactory: mainViewStateFactory)
            }
            return self.mainKitchen
        }
        container.storyboardInitCompleted(MainViewController.self) { resolver, controller in
            let mainKitchen = resolver.forceResolve(MainKitchen.self)
            controller.inject(kitchen: mainKitchen)
            mainKitchen.delegate = AnyKitchenDelegate(controller)
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
        
        //MARK: - Article
        
        container.register(ArticleViewStateFactory.self) { resolver in
            let articleConverter = resolver.forceResolve(ArticleConverter.self)
            return ArticleViewStateFactory(articleConverter: articleConverter)
        }
        container.register(ArticleStateVariables.self) { resolver in
            return ArticleStateVariables()
        }
        container.register(ArticleKitchen.self) { resolver in
            let articleViewStateFactory = resolver.forceResolve(ArticleViewStateFactory.self)
            let networkManager = resolver.forceResolve(NetworkManager.self)
            let articleStateVariables = resolver.forceResolve(ArticleStateVariables.self)
            return ArticleKitchen(networkManager: networkManager, articleViewStateFactory: articleViewStateFactory, articleStateVariables: articleStateVariables)
        }
        container.storyboardInitCompleted(ArticleViewController.self) { resolver, controller in
            let articleKitchen = resolver.forceResolve(ArticleKitchen.self)
            controller.inject(kitchen: articleKitchen)
            articleKitchen.delegate = AnyKitchenDelegate(controller)
        }
        
        //MARK: - Gallery
        
        container.register(GalleryViewStateFactory.self) { _ in
            return GalleryViewStateFactory()
        }
        container.register(GalleryKitchen.self) { resolver in
            let galleryViewStateFactory = resolver.forceResolve(GalleryViewStateFactory.self)
            return GalleryKitchen(galleryViewStateFactory: galleryViewStateFactory)
        }
        container.storyboardInitCompleted(GalleryViewController.self) { resolver, controller in
            let galleryKitchen = resolver.forceResolve(GalleryKitchen.self)
            controller.inject(kitchen: galleryKitchen)
            galleryKitchen.delegate = AnyKitchenDelegate(controller)
        }
    }
}
