//
//  MenuContract.swift
//  Langkawi-iOS
//
//  Created by 松尾 勇気（Yuki Matsuo） on 2022/10/11.
//

import UIKit

protocol MenuUseCase: AnyObject {
    func logout()
    func isLoggedIn() -> Bool
}

protocol MenuInteractorOutput: AnyObject {
    func onLogout()
    func onError(error: Error)
}

protocol MenuPresentation: AnyObject {
    func showLogin()
    func doLogout()
    func showServiceRule()
    func showCopyright()
    
    func showLoginRow() -> Bool
}

protocol MenuWireframe: AnyObject {
    static func assemble() -> MenuViewController
    
    func presentLogin()
    func presentServiceRule()
    func presentCopyright()
}

protocol MenuViewProtocol: AnyObject {}
