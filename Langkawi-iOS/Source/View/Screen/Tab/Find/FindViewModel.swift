//
//  FindViewModel.swift
//  Langkawi-iOS
//
//  Created by Yuki Matsuo on 2022/09/20.
//

import Combine

class FindViewModel: SwinjectSupport {
    
    private lazy var userAPI = resolveInstance(UserAPI.self)
    
    var requester: UsersViewModel.Requester {
        return { [weak self] (page: Int, pageSize: Int) -> AnyPublisher<[User], Error>? in
            self?.userAPI.users(page: page, pageSize: pageSize).map { $0.list }.eraseToAnyPublisher()
        }
    }
}
