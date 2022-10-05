//
//  UserDetailAPI.swift
//  Langkawi-iOS
//
//  Created by Yuki Matsuo on 2022/09/27.
//

import Combine

protocol UserDetailAPI {
    
    func updateDescription(userDetailId: Int, description: String) -> AnyPublisher<UserDetail, Error>
}

class UserDetailAPIImpl: BaseAPI, UserDetailAPI {
    
    func updateDescription(userDetailId: Int, description: String) -> AnyPublisher<UserDetail, Error> {
        return putRequest(
            path: "/user_details/\(userDetailId)",
            model: UserDetail.self,
            parameters: ["description_a": description]
        )
    }
}
