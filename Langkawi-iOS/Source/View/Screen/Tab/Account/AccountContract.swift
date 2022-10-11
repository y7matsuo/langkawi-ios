//
//  AccountContract.swift
//  Langkawi-iOS
//
//  Created by 松尾 勇気（Yuki Matsuo） on 2022/10/11.
//

import UIKit

protocol AccountUseCase: BaseUseCase {
    func fetchUser(userId: Int)
    func fetchAvator(userId: Int)
}

protocol AccountInteractorOutput: BaseInteractorOutput {
    func onFetchUser(user: User)
    func onFetchAvator(image: UIImage)
}

protocol AccountPresentation: BasePresentation {
    func fetchAccount()
    
    func showEditName()
    func showEditDescription()
}

protocol AccountWireframe: BaseWireframe {
    static func assemble() -> AccountViewProtocol
    
    func presentEditName()
    func presentEditDescription()
}

protocol AccountViewProtocol: BaseViewProtocol {}
