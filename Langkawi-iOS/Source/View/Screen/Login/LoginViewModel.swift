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
        LoginSessionManager.storeSession(token: response.token, userId: response.userId)
    }
}
