//
//  PositionStatusUsersViewModel.swift
//  Langkawi-iOS
//
//  Created by Yuki Matsuo on 2022/09/20.
//

import Combine

class PositionStatusUsersViewModel: SwinjectSupport {
    private lazy var relationAPI = resolveInstance(RelationAPI.self)
    
    var positionStatus: RelationPositionStatus?
    
    var requester: UsersViewModel.Requester {
        return { [weak self] (page: Int, pageSize:Int) -> AnyPublisher<[User], Error>? in
            guard let positionStatus = self?.positionStatus else {
                return nil
            }
            return self?.relationAPI
                .relations(page: page, pageSize: pageSize, positionStatus: positionStatus)
                .map { relations in relations.list.map { $0.user } }
                .eraseToAnyPublisher()
        }
    }
}
