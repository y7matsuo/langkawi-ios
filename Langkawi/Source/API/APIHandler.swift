//
//  APIHandler.swift
//  Langkawi-iOS
//
//  Created by Yuki Matsuo on 2022/09/11.
//

import UIKit
import Combine

protocol APIHandler: UIViewController {}

extension APIHandler {
    
    func request<T>(
        errorHandler: ((Error) -> Bool)? = nil,
        requester: () -> AnyPublisher<T, Error>?,
        handler: @escaping (T) -> Void
    ) -> AnyCancellable? {
        return requester()?
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] in
                switch $0 {
                case .finished:
                    break
                case .failure(let error):
                    var cont = true
                    if let errorHandler = errorHandler {
                        cont = errorHandler(error)
                    }
                    
                    if cont {
                        GlobalErrorHandler.handle(error: error, vc: self)
                    }
                }
            }, receiveValue: handler)
    }
}
