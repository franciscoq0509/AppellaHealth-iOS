//
//  AppContract.swift
//  Appella Health
//
//  Created by F.Q. on 26.03.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import BrightFutures

protocol NetworkManager {
    func login(login: String, password: String) -> Future<User, AnyError>
    func register(firstName: String, lastName: String, email: String, password: String) -> Future<String, AnyError>
    func remindPassword(email: String) -> Future<String, AnyError>
    @discardableResult func switchNotificationStatus(status: Bool) -> Future<String, AnyError>
    func getNotificationsStatus() -> Future<Bool, AnyError>
    func getPrivacyPolicy() -> Future<String, AnyError>
    func getArticles(category: ArticleCategory) -> Future<[Article], AnyError>
    func getArticle(articleId: Int) -> Future<Article, AnyError>
    func recordDeepView(articleId: Int) -> Future<Void, AnyError>
}
