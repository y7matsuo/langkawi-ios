//
//  TalkAPI.swift
//  Langkawi-iOS
//
//  Created by Yuki Matsuo on 2022/09/30.
//

import Combine

protocol TalkAPI {
    
    func talks(relationId: Int, page: Int, pageSize: Int) -> AnyPublisher<TalksResponse, Error>
    
    func talkRooms(page: Int, pageSize: Int) -> AnyPublisher<TalkRoomsResponse, Error>
    
    func createTalk(relationId: Int, message: String) -> AnyPublisher<TalkResponse, Error>
    
    func updateTalk(id: Int, message: String?, status: TalkStatus?) -> AnyPublisher<TalkResponse, Error>
}

class TalkAPIImpl: BaseAPI, TalkAPI {
    
    func talks(relationId: Int, page: Int, pageSize: Int) -> AnyPublisher<TalksResponse, Error> {
        return getRequest(
            path: "/talks",
            model: TalksResponse.self,
            parameters: ["relation_id": relationId, "page": page, "page_size": pageSize]
        )
    }
    
    func talkRooms(page: Int, pageSize: Int) -> AnyPublisher<TalkRoomsResponse, Error> {
        return getRequest(
            path: "/talks/rooms",
            model: TalkRoomsResponse.self,
            parameters: ["page": page, "page_size": pageSize]
        )
    }
    
    func createTalk(relationId: Int, message: String) -> AnyPublisher<TalkResponse, Error> {
        return postRequest(
            path: "/talks",
            model: TalkResponse.self,
            parameters: ["relation_id": relationId, "message": message]
        )
    }
    
    func updateTalk(id: Int, message: String?, status: TalkStatus?) -> AnyPublisher<TalkResponse, Error> {
        return putRequest(
            path: "/talks/\(id)",
            model: TalkResponse.self,
            parameters: ["message": message, "status": status?.rawValue].compactParameters()
        )
    }
}
