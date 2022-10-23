//
//  AccountPresenter.swift
//  Langkawi-iOS
//
//  Created by 松尾 勇気（Yuki Matsuo） on 2022/10/11.
//

import UIKit

class AccountPresenter: AccountPresentation {
    private let vm: AccountViewModel
    private let interactor: AccountUseCase
    private let router: AccountWireframe
    weak var view: AccountViewProtocol?

    init(vm: AccountViewModel, interactor: AccountUseCase, router: AccountWireframe) {
        self.vm = vm
        self.interactor = interactor
        self.router = router
    }
    
    func fetchAccount() {
        guard let userId = interactor.getUserId() else {
            return
        }
        interactor.fetchAvator(userId: userId)
        interactor.fetchUser(userId: userId)
    }
    
    func showEditName() {
        router.presentEditName()
    }
    
    func showEditDescription() {
        router.presentEditDescription()
    }
}

extension AccountPresenter: AccountInteractorOutput {
    func onFetchUser(user: User) {
        self.vm.name = user.toNameLabelText()
        self.vm.gender = user.toGenderText()
        self.vm.genderColor = user.toGenderColor()
        self.vm.age = user.toAgeLabelText()
        self.vm.description = user.detail?.descriptionA ?? ""
    }
    
    func onFetchAvator(image: UIImage) {
        self.vm.avator = image
    }
    
    func onError(error: Error) {
        GlobalErrorHandler.handle(error: error, vc: view as? UIViewController)
    }
}
