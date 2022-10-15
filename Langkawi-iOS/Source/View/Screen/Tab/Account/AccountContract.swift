//
//  AccountContract.swift
//  Langkawi-iOS
//
//  Created by 松尾 勇気（Yuki Matsuo） on 2022/10/11.
//

import UIKit

/// @mockable
protocol AccountUseCase: AnyObject {
    func fetchUser(userId: Int)
    func fetchAvator(userId: Int)
    func getUserId() -> Int?
}

/// @mockable
protocol AccountInteractorOutput: AnyObject {
    func onFetchUser(user: User)
    func onFetchAvator(image: UIImage)
    func onError(error: Error)
}

/// @mockable
protocol AccountPresentation: AnyObject {
    func fetchAccount()
    
    func showEditName()
    func showEditDescription()
}

/// @mockable
protocol AccountWireframe: AnyObject {
    static func assemble() -> AccountViewController
    
    func presentEditName()
    func presentEditDescription()
}

/// @mockable
protocol AccountViewProtocol: AnyObject {}
