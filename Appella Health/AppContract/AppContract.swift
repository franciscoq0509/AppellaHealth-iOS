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
    func register(name: String, email: String, password: String) -> Future<String, AnyError>
    func remindPassword(email: String) -> Future<String, AnyError>
    func switchNotificationStatus(userId: String, status: Bool) -> Future<String, AnyError>
    func getNotificationsStatus(userId: String) -> Future<Bool, AnyError>
    func getPrivacyPolicy() -> Future<String, AnyError>
}
