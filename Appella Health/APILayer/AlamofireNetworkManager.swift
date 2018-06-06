//
//  AlamofireNetworkManager.swift
//  Appella Health
//
//  Created by F.Q. on 26.03.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import Alamofire
import BrightFutures

class AlamofireNetworkManager: NetworkManager {
    
    let serviceUrl = "https://transpara.org/api/mobile"
    
    enum WebServiceMethods {
        static let login = "login"
        static let register = "register"
        static let forgotPassword = "forgot_password"
        static let news = "news"
        static let updateUser = "update_user"
        static let userInfo = "user_info"
        static let privacyPolicy = "privacy_policy"
        static let recordDeepView = "record_deep_view"
    }
    
    enum WebServiceParameters {
        static let email = "email"
        static let password = "password"
        static let firstName = "first_name"
        static let lastName = "last_name"
        static let categoryId = "category_id"
        static let xApiKey = "x-api-key"
        static let newsId = "news_id"
        static let notifications = "notifications"
    }
    
    enum Errors {
        static let failedToGetDataFromResponse = "Failed to get data from response"
    }
    
    private let errorHandler: ErrorHandler
    
    private var headers: HTTPHeaders {
        guard let apiKey = UserDefaults.getApiKey() else {
            fatalError("No api key found in stored properties")
        }
        return [WebServiceParameters.xApiKey: apiKey]
    }
    
    init(errorHandler: ErrorHandler) {
        self.errorHandler = errorHandler
    }
    
    private func getUrl(with method: String) -> URL{
        guard var url = URL(string: serviceUrl) else {
            fatalError("Unexpected service url")
        }
        url.appendPathComponent(method)
        return url
    }
    
    func login(login: String, password: String) -> Future<User, AnyError>{
        let promise = Promise<User, AnyError>()
        let requestUrl = getUrl(with: WebServiceMethods.login)
        let parameters = [WebServiceParameters.email: login,
                          WebServiceParameters.password: password]
        Alamofire.request(requestUrl, method: .post, parameters: parameters).responseJSON { response in
            if let error = response.error {
                promise.failure(AnyError(error.localizedDescription))
                print(error)
                return
            }
            guard let data = response.data else {
                promise.failure(AnyError(Errors.failedToGetDataFromResponse))
                return
            }
            if let response = Response(data) {
                promise.failure(AnyError(response.responseMessage.message))
                return
            }
            do {
                let userResponse = try JSONDecoder().decode(UserResponse.self, from: data)
                promise.success(userResponse.user)
            }
            catch {
                promise.failure(AnyError(error.localizedDescription))
                print(error)
            }
        }
        return promise.future
    }
    
    func register(firstName: String, lastName: String, email: String, password: String) -> Future<String, AnyError> {
        let promise = Promise<String, AnyError>()
        let requestUrl = getUrl(with: WebServiceMethods.register)
        let parameters = [WebServiceParameters.email: email,
                          WebServiceParameters.password: password,
                          WebServiceParameters.firstName: firstName,
                          WebServiceParameters.lastName: lastName]
        Alamofire.request(requestUrl, method: .post, parameters: parameters).responseJSON { [weak self] response in
            guard let _self = self else {
                return
            }
            if let error = response.error {
                promise.failure(AnyError(error.localizedDescription))
                print(error)
                return
            }
            guard let data = response.data else {
                promise.failure(AnyError(Errors.failedToGetDataFromResponse))
                return
            }
            _self.decodeResponse(data: data, promise: promise)
        }
        return promise.future
    }
    
    func remindPassword(email: String) -> Future<String, AnyError> {
        let promise = Promise<String, AnyError>()
        let requestUrl = getUrl(with: WebServiceMethods.forgotPassword)
        let parameters = [WebServiceParameters.email: email]
        Alamofire.request(requestUrl, method: .post, parameters: parameters).responseJSON { [weak self]
            response in
            guard let _self = self else {
                return
            }
            if let error = response.error {
                promise.failure(AnyError(error.localizedDescription))
                print(error)
                return
            }
            guard let data = response.data else {
                promise.failure(AnyError(Errors.failedToGetDataFromResponse))
                return
            }
            _self.decodeResponse(data: data, promise: promise)
        }
        return promise.future
    }
    
    private func decodeResponse(data: Data, promise: Promise<String, AnyError>) {
        do {
            let response = try JSONDecoder().decode(Response.self, from: data)
            switch response.status {
            case .ok:
                promise.success(response.responseMessage.message)
            case .error:
                promise.failure(AnyError(response.responseMessage.message))
            }
        }
        catch {
            promise.failure(AnyError(error.localizedDescription))
            print(error)
        }
    }
    
    @discardableResult
    func switchNotificationStatus(status: Bool) -> Future<String, AnyError> {
        let promise = Promise<String, AnyError>()
        let requestUrl = getUrl(with: WebServiceMethods.updateUser)
        let parameters: Parameters = [WebServiceParameters.notifications: status]
        Alamofire.request(requestUrl, method: .post, parameters: parameters, headers: headers).responseJSON { [weak self] response in
            guard let _self = self else {
                return
            }
            if let statusCode = response.response?.statusCode, let errorCode = ErrorCode(rawValue: statusCode) {
                let error = _self.errorHandler.handle(errorCode: errorCode)
                promise.failure(AnyError(error))
                return
            }
            if let error = response.error {
                promise.failure(AnyError(error.localizedDescription))
                print(error)
                return
            }
            guard let data = response.data else {
                promise.failure(AnyError(Errors.failedToGetDataFromResponse))
                return
            }
            if let response = Response(data) {
                switch response.status {
                case .ok:
                    promise.success(response.responseMessage.message)
                case .error:
                    promise.failure(AnyError(response.responseMessage.message))
                }
            }
            else {
                promise.success("")
            }
        }
        return promise.future
    }
    
    func getNotificationsStatus() -> Future<Bool, AnyError> {
        let promise = Promise<Bool, AnyError>()
        let requestUrl = getUrl(with: WebServiceMethods.userInfo)
        Alamofire.request(requestUrl, headers: headers).responseJSON { [weak self] response in
            guard let _self = self else {
                return
            }
            if let statusCode = response.response?.statusCode, let errorCode = ErrorCode(rawValue: statusCode) {
                let error = _self.errorHandler.handle(errorCode: errorCode)
                promise.failure(AnyError(error))
                return
            }
            if let error = response.error {
                promise.failure(AnyError(error.localizedDescription))
                print(error)
                return
            }
            guard let data = response.data else {
                promise.failure(AnyError(Errors.failedToGetDataFromResponse))
                return
            }
            if let response = Response(data) {
                promise.failure(AnyError(response.responseMessage.message))
                return
            }
            do {
                let userInfoResponse = try JSONDecoder().decode(UserInfoResponse.self, from: data)
                promise.success(userInfoResponse.userInfo.notifications == 0 ? false : true)
            }
            catch {
                promise.failure(AnyError(error.localizedDescription))
                print(error)
            }
        }
        return promise.future
    }
    
    func getPrivacyPolicy() -> Future<String, AnyError> {
        let promise = Promise<String, AnyError>()
        let requestUrl = getUrl(with: WebServiceMethods.privacyPolicy)
        Alamofire.request(requestUrl, method: .get, headers: headers).responseJSON { [weak self] response in
            guard let _self = self else {
                return
            }
            if let statusCode = response.response?.statusCode, let errorCode = ErrorCode(rawValue: statusCode) {
                let error = _self.errorHandler.handle(errorCode: errorCode)
                promise.failure(AnyError(error))
                return
            }
            if let error = response.error {
                promise.failure(AnyError(error.localizedDescription))
                print(error)
                return
            }
            guard let data = response.data else {
                promise.failure(AnyError(Errors.failedToGetDataFromResponse))
                return
            }
            if let response = Response(data) {
                promise.failure(AnyError(response.responseMessage.message))
                return
            }
            do {
                let privacyPolicyResponse = try JSONDecoder().decode(PrivacyPolicyResponse.self, from: data)
                promise.success(privacyPolicyResponse.privacyPolicy.privacyPolicy)
            }
            catch {
                promise.failure(AnyError(error.localizedDescription))
                print(error)
            }
        }
        return promise.future
    }
    
    func getArticles(category: ArticleCategory) -> Future<[Article], AnyError> {
        let promise = Promise<[Article], AnyError>()
        let requestUrl = getUrl(with: WebServiceMethods.news)
        let parameters: Parameters = category.rawValue != 0 ? [WebServiceParameters.categoryId: category.rawValue]: [:]
        Alamofire.request(requestUrl, parameters: parameters, headers: self.headers).responseJSON { [weak self] response in
            guard let _self = self else {
                return
            }
            if let statusCode = response.response?.statusCode, let errorCode = ErrorCode(rawValue: statusCode) {
                let error = _self.errorHandler.handle(errorCode: errorCode)
                promise.failure(AnyError(error))
                return
            }
            if let error = response.error {
                promise.failure(AnyError(error.localizedDescription))
                print(error)
                return
            }
            guard let data = response.data else {
                promise.failure(AnyError(Errors.failedToGetDataFromResponse))
                return
            }
            if let response = Response(data) {
                promise.failure(AnyError(response.responseMessage.message))
                return
            }
            do {
                let newsResponse = try JSONDecoder().decode(ArticlesResponse.self, from: data)
                promise.success(newsResponse.articles)
            }
            catch {
                promise.failure(AnyError(error.localizedDescription))
                print (error)
            }
        }
        return promise.future
    }
    
    func getArticle(articleId: Int) -> Future<Article, AnyError> {
        let promise = Promise<Article, AnyError>()
        var requestUrl = getUrl(with: WebServiceMethods.news)
        requestUrl.appendPathComponent(String(articleId))
        Alamofire.request(requestUrl, headers: headers).responseJSON { [weak self] response in
            guard let _self = self else {
                return
            }
            if let statusCode = response.response?.statusCode, let errorCode = ErrorCode(rawValue: statusCode) {
                let error = _self.errorHandler.handle(errorCode: errorCode)
                promise.failure(AnyError(error))
                return
            }
            if let error = response.error {
                promise.failure(AnyError(error.localizedDescription))
                print(error)
                return
            }
            guard let data = response.data else {
                promise.failure(AnyError(Errors.failedToGetDataFromResponse))
                return
            }
            if let response = Response(data) {
                promise.failure(AnyError(response.responseMessage.message))
                return
            }
            do {
                let articleResponse = try JSONDecoder().decode(ArticleResponse.self, from: data)
                promise.success(articleResponse.article)
            }
            catch {
                promise.failure(AnyError(error.localizedDescription))
                print(error)
            }
        }
        return promise.future
    }
    
    func recordDeepView(articleId: Int) -> Future<Void, AnyError> {
        let promise = Promise<Void, AnyError>()
        var requestUrl = getUrl(with: WebServiceMethods.news)
        requestUrl.appendPathComponent(WebServiceMethods.recordDeepView)
        requestUrl.appendPathComponent(String(articleId))
        Alamofire.request(requestUrl, method: .post, headers: headers).responseJSON { [weak self] response in
            guard let _self = self else {
                return
            }
            if let statusCode = response.response?.statusCode, let errorCode = ErrorCode(rawValue: statusCode) {
                let error = _self.errorHandler.handle(errorCode: errorCode)
                promise.failure(AnyError(error))
            }
            if let error = response.error {
                print(error)
            }
        }
        
        return promise.future
    }
}
