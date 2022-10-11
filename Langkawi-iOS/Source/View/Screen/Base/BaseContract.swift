//
//  BaseContract.swift
//  Langkawi-iOS
//
//  Created by 松尾 勇気（Yuki Matsuo） on 2022/10/11.
//

import UIKit
import Combine

protocol BaseUseCase: AnyObject {}

protocol BaseInteractorOutput: AnyObject {
    func onError(error: Error)
}

protocol BasePresentation: AnyObject {}

protocol BaseWireframe: AnyObject {}

protocol BaseViewProtocol: UIViewController {}

extension BaseUseCase {
    
    func request<T>(
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
