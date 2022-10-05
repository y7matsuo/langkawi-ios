//
//  LoginViewModel.swift
//  Langkawi-iOS
//
//  Created by Yuki Matsuo on 2022/09/11.
//

import Combine
import UIKit
import RealmSwift

class LoginViewModel: SwinjectSupport {
    
    lazy var loginAPI = resolveInstance(LoginAPI.self)
    
    func loginCompletion(response: LoginResponse) {
        LoginTokenManager.storeToken(token: response.token)
        LoginTokenManager.storeLoginUserId(userId: response.userId)
    }
}
