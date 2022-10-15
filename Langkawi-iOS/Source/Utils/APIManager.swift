//
//  APIManager.swift
//  Langkawi-iOS
//
//  Created by 松尾 勇気（Yuki Matsuo） on 2022/10/14.
//

import Combine
import UIKit

class APIManager {
    
    static func request<T>(
        requester: () -> AnyPublisher<T, Error>?,
        errorHandler: @escaping (Error) -> Void,
        handler: @escaping (T) -> Void
    ) -> AnyCancellable? {
        return requester()?
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: {
                switch $0 {
                case .finished:
                    break
                case .failure(let error):
                    errorHandler(error)
                }
            }, receiveValue: handler)
    }
}
