//
//  LoginAPI.swift
//  Langkawi-iOS
//
//  Created by Yuki Matsuo on 2022/09/10.
//

import Combine

protocol LoginAPI {
    func login(email: String, password: String) -> AnyPublisher<LoginResponse, Error>
    
    func logout() -> AnyPublisher<SuccessReponse, Error>
}

class LoginAPIImpl: BaseAPI, LoginAPI {
    func login(email: String, password: String) -> AnyPublisher<LoginResponse, Error> {
        return postRequest(
            path: "/login",
            model: LoginResponse.self,
            parameters: ["email": email, "password": password],
            interceptor: nil
        )
    }
    
    func logout() -> AnyPublisher<SuccessReponse, Error> {
        return postRequest(path: "/logout", model: SuccessReponse.self)
    }
}
