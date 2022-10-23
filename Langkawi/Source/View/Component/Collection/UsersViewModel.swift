//
//  UsersViewModel.swift
//  Langkawi-iOS
//
//  Created by Yuki Matsuo on 2022/09/14.
//

import Combine
import UIKit

class UsersViewModel<T: UserCell>: SwinjectSupport {
    typealias Requester = (_ page: Int, _ pageSize: Int) -> AnyPublisher<[User], Error>?
    var requester: Requester?
    
    private lazy var userApi = resolveInstance(UserAPI.self)
    private lazy var imageApi = resolveInstance(ImageAPI.self)
    
    private weak var owner: UsersViewController<T>?
    
    private var users: [User] = []
    
    init(owner: UsersViewController<T>) {
        self.owner = owner
    }
    
    func setup() {
        owner?.useEffect(dependencies: [
            LoginSessionManager.loginSessionStored.eraseToAnyPublisher()
        ]) { [weak self] in
            self?.fetch(page: 0)
        }
    }
    
    func fetch(page: Int, pageSize: Int = 100) -> AnyCancellable? {
        return owner?.request(requester: { [weak self] in
            self?.requester?(page, pageSize)
        }) { [weak self] in
            self?.users = $0
            self?.owner?.collectionView?.reloadData()
        }
    }
    
    func resolveUser(index: Int) -> User? {
        guard index < users.count else {
            return nil
        }
        return users[index]
    }
    
    func resolveCount() -> Int {
        return users.count
    }
}
