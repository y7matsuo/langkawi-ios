//
//  MenuRouter.swift
//  Langkawi-iOS
//
//  Created by 松尾 勇気（Yuki Matsuo） on 2022/10/11.
//

import UIKit

class MenuRouter: MenuWireframe {
    weak var view: UIViewController?
    
    static func assemble() -> MenuViewController {
        let interactor = MenuInteractor(loginAPI: LoginAPIImpl())
        let router = MenuRouter()
        let presenter = MenuPresenter(interactor: interactor, router: router)
        interactor.output = presenter
        let view = MenuViewController()
        view.presenter = presenter
        router.view = view
        return view
    }
    
    func presentLogin() {
        let vc = LoginViewController()
        vc.modalPresentationStyle = .fullScreen
        view?.present(vc, animated: true)
    }
}
