//
//  MenuContract.swift
//  Langkawi-iOS
//
//  Created by 松尾 勇気（Yuki Matsuo） on 2022/10/11.
//

import UIKit

protocol MenuUseCase: BaseUseCase {
    func logout()
}

protocol MenuInteractorOutput: BaseInteractorOutput {
    func onLogout()
}

protocol MenuPresentation: BasePresentation {
    func showLogin()
    func doLogout()
    
    func showLoginRow() -> Bool
}

protocol MenuWireframe: BaseWireframe {
    static func assemble() -> MenuViewController
    
    func presentLogin()
}

protocol MenuViewProtocol: BaseViewProtocol {}
