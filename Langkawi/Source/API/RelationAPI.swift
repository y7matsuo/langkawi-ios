//
//  RelationAPI.swift
//  Langkawi-iOS
//
//  Created by Yuki Matsuo on 2022/09/18.
//

import Combine

protocol RelationAPI {
    
    func relations(page: Int, pageSize: Int, positionStatus: RelationPositionStatus) -> AnyPublisher<RelationsResponse, Error>
    
    func relation(userId: Int) -> AnyPublisher<RelationResponse, Error>
    
    func createRelation(userId: Int) -> AnyPublisher<RelationResponse, Error>
    
    func updateRelation(userId: Int, status: RelationStatus) -> AnyPublisher<RelationResponse, Error>
}

class RelationAPIImpl: BaseAPI, RelationAPI {
    
    func relations(page: Int, pageSize: Int, positionStatus: RelationPositionStatus) -> AnyPublisher<RelationsResponse, Error> {
        return getRequest(
            path: "/relations",
            model: RelationsResponse.self,
            parameters: [
                "page": page,
                "page_size": pageSize,
                "position_status": positionStatus.rawValue
            ]
        )
    }
    
    func relation(userId: Int) -> AnyPublisher<RelationResponse, Error> {
        return getRequest(
            path: "/relations/\(userId)",
            model: RelationResponse.self
        )
    }
    
    func createRelation(userId: Int) -> AnyPublisher<RelationResponse, Error> {
        return postRequest(
            path: "/relations",
            model: RelationResponse.self,
            parameters: ["user_id": userId]
        )
    }
    
    func updateRelation(userId: Int, status: RelationStatus) -> AnyPublisher<RelationResponse, Error> {
        return putRequest(
            path: "/relations/\(userId)",
            model: RelationResponse.self,
            parameters: ["status": status.rawValue]
        )
    }
}
