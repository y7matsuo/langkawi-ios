//
//  MenuPresenter.swift
//  Langkawi-iOS
//
//  Created by 松尾 勇気（Yuki Matsuo） on 2022/10/11.
//

import Combine

class MenuPresenter: MenuPresentation {
    weak var view: MenuViewProtocol?
    private let interactor: MenuUseCase
    private let router: MenuWireframe
    
    init(interactor: MenuUseCase, router: MenuWireframe) {
        self.interactor = interactor
        self.router = router
    }
    
    func showLogin() {
        router.presentLogin()
    }
    
    func doLogout() {
        interactor.logout()
    }
    
    func showLoginRow() -> Bool {
        return LoginSessionManager.getLoginUserId() == nil
    }
}

extension MenuPresenter: MenuInteractorOutput {
    func onLogout() {
        LoginSessionManager.deleteSession()
    }
    
    func onError(error: Error) {
        GlobalErrorHandler.handle(error: error, vc: view)
    }
}
