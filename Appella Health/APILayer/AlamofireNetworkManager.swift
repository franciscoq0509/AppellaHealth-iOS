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
    
    let serviceUrl = "http://transpara.org/appellahealth/webservices2/"
    
    enum WebServiceMethods {
        static let login = "login.php"
        static let register = "register.php"
        static let forgotPassword = "forgot_password.php"
        static let getNews = "get_news1.php"
        static let changeNotificationStatus = "change_notification_status.php"
        static let getNotificationStatus = "get_notification_status.php"
        static let getStaticPageData = "get_staticpage_data.php"
    }
    
    enum WebServiceParameters {
        static let email = "email"
        static let password = "password"
        static let userName = "username"
        static let type = "type"
        static let pagination = "pagination"
        static let start = "start"
        static let userId = "user_id"
        static let status = "status"
        static let id = "id"
    }
    
    enum Errors {
        static let failedToGetDataFromResponse = "Failed to get data from response"
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
                promise.failure(AnyError(response.responseData.message))
                return
            }
            do {
                let userResponse = try JSONDecoder().decode(UserResponse.self, from: data)
                promise.success(userResponse.responseData.user)
            }
            catch {
                promise.failure(AnyError(error.localizedDescription))
                print(error)
            }
        }
        return promise.future
    }
    
    func register(name: String, email: String, password: String) -> Future<String, AnyError> {
        let promise = Promise<String, AnyError>()
        let requestUrl = getUrl(with: WebServiceMethods.register)
        let parameters = [WebServiceParameters.email: email,
                          WebServiceParameters.password: password,
                          WebServiceParameters.userName: name]
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
            guard let responseStatus = ResponseStatus(rawValue: response.responseData.result) else {
                promise.failure(AnyError(response.responseData.message))
                return
            }
            switch responseStatus {
            case .success:
                promise.success(response.responseData.message)
            default:
                promise.failure(AnyError(response.responseData.message))
            }
        }
        catch {
            promise.failure(AnyError(error.localizedDescription))
            print(error)
        }
    }
    
    func switchNotificationStatus(userId: String, status: Bool) -> Future<String, AnyError> {
        let promise = Promise<String, AnyError>()
        let requestUrl = getUrl(with: WebServiceMethods.changeNotificationStatus)
        let parameters: Parameters = [WebServiceParameters.userId: userId,
                          WebServiceParameters.status: status ? 1 : 0]
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
    
    func getNotificationsStatus(userId: String) -> Future<Bool, AnyError> {
        let promise = Promise<Bool, AnyError>()
        let requestUrl = getUrl(with: WebServiceMethods.getNotificationStatus)
        let parameters = [WebServiceParameters.userId: userId]
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
                promise.failure(AnyError(response.responseData.message))
                return
            }
            do {
                let notificationStatusResponse = try JSONDecoder().decode(NotificationStatusResponse.self, from: data)
                promise.success(notificationStatusResponse.responseData.getStatus())
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
        let requestUrl = getUrl(with: WebServiceMethods.getStaticPageData)
        let parameters = [WebServiceParameters.id: 2]
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
            do {
                let pageResponse = try JSONDecoder().decode(PageResponse.self, from: data)
                guard let responseStatus = ResponseStatus(rawValue: pageResponse.responseData.result) else {
                    promise.failure(AnyError(pageResponse.responseData.message))
                    return
                }
                switch responseStatus {
                case .success:
                    promise.success(pageResponse.responseData.content)
                default:
                    promise.failure(AnyError(pageResponse.responseData.message))
                }
            }
            catch {
                promise.failure(AnyError(error.localizedDescription))
                print(error)
            }
        }
        return promise.future
    }
    
//    func getNews(type: ArticleCategory, from: Int, pagination: Int = 1) -> Future<Void, AnyError> {
//        let promise = Promise<Void, AnyError>()
//        let requestUrl = getUrl(with: WebServiceMethods.getNews)
//        let parameters: Parameters = [WebServiceParameters.type: type.rawValue,
//                          WebServiceParameters.start: from,
//                          WebServiceParameters.pagination: pagination]
//        Alamofire.request(requestUrl, method: .post, parameters: parameters).responseJSON(completionHandler: { response in
//            if let error = response.error {
//                promise.failure(AnyError(error.localizedDescription))
//                print(error)
//                return
//            }
//            guard let data = response.data else {
//                promise.failure(AnyError(Errors.failedToGetDataFromResponse))
//                return
//            }
//            
//        }
//    }
}
