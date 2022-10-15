//
//  MenuInteractor.swift
//  Langkawi-iOS
//
//  Created by 松尾 勇気（Yuki Matsuo） on 2022/10/11.
//

import Combine

class MenuInteractor: MenuUseCase {
    private let loginAPI: LoginAPI
    weak var output: MenuInteractorOutput?
    
    private var cancellables = Set<AnyCancellable>()
    
    init(loginAPI: LoginAPI) {
        self.loginAPI = loginAPI
    }
    
    func logout() {
        APIManager.request(
            requester: { self.loginAPI.logout() },
            errorHandler: { [weak self] in self?.output?.onError(error: $0) }
        ) { [weak self] _ in
            self?.output?.onLogout()
        }?.store(in: &cancellables)
    }
    
    func isLoggedIn() -> Bool {
        return LoginSessionManager.getLoginUserId() != nil
    }
}
