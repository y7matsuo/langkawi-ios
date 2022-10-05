//
//  UseEffectSupport.swift
//  Langkawi-iOS
//
//  Created by Yuki Matsuo on 2022/09/15.
//

import Foundation
import Combine

class UseEffectSupportInjector: LifecycleInjector {
    private let dependencies: [AnyPublisher<Bool, Never>]
    private let effector: () -> AnyCancellable?
    private var cancellable: AnyCancellable?
    private var cancellables: Set<AnyCancellable> = []
    
    init(dependencies: [AnyPublisher<Bool, Never>], effector: @escaping () -> AnyCancellable?) {
        self.dependencies = dependencies
        self.effector = effector
        sink()
    }
    
    func onViewWillAppear() {
        cancellable = effector()
    }
    
    func onViewDidDisappear() {
        cancellable?.cancel()
    }
    
    private func sink() {
        dependencies.forEach { dependency in
            dependency.sink { [weak self] in
                guard $0 else { return }
                self?.cancellable = self?.effector()
            }.store(in: &cancellables)
        }
    }
}

protocol UseEffectSupport: LifecycleInjectableViewController {}

extension UseEffectSupport {
    
    func useEffect(
        dependencies: [AnyPublisher<Bool, Never>] = [],
        effector: @escaping () -> AnyCancellable?
    ) {
        let injector = UseEffectSupportInjector(dependencies: dependencies, effector: effector)
        registerLifecycleInjector(injector: injector)
    }
}
