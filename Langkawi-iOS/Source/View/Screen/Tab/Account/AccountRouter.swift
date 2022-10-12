//
//  AccountRouter.swift
//  Langkawi-iOS
//
//  Created by 松尾 勇気（Yuki Matsuo） on 2022/10/11.
//

import UIKit

class AccountRouter: AccountWireframe {
    weak var view: UIViewController?
    
    static func assemble() -> AccountViewProtocol {
        let interactor = AccountInteractor(userAPI: UserAPIImpl(), imageAPI: ImageAPIImpl())
        let vm = AccountViewModel()
        let router = AccountRouter()
        let presenter = AccountPresenter(vm: vm, interactor: interactor, router: router)
        interactor.output = presenter
        let view = AccountViewController(vm: vm, presenter: presenter)
        router.view = view
        return view
    }
    
    func presentEditName() {
        view?.navigationController?.pushViewController(NameEditViewController(), animated: false)
    }
    
    func presentEditDescription() {
        view?.navigationController?.pushViewController(DescriptionEditViewController(), animated: false)
    }
}
