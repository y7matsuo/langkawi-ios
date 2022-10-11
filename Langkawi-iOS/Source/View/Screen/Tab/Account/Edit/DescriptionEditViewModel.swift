//
//  DescriptionEditViewModel.swift
//  Langkawi-iOS
//
//  Created by Yuki Matsuo on 2022/09/27.
//

import Combine
import Foundation

class DescriptionEditViewModel: SwinjectSupport {
    private lazy var userAPI = resolveInstance(UserAPI.self)
    private lazy var userDetailAPI = resolveInstance(UserDetailAPI.self)
    
    private lazy var userId = LoginSessionManager.getLoginUserId()
    
    private weak var owner: OwnerVC?
    private var cancellables = Set<AnyCancellable>()
    
    @Published private var user: User?
    @Published var description: String?
    
    init(owner: OwnerVC) {
        self.owner = owner
    }
    
    func setup() {
        owner?.useEffect { [weak self] in
            self?.owner?.request(requester: { () -> AnyPublisher<User, Error>? in
                guard let userId = self?.userId else {
                    return nil
                }
                return self?.userAPI.user(userId: userId)
            }) {
                self?.user = $0
            }
        }
        
        $user.sink { [weak self] in
            self?.description = $0?.detail?.descriptionA
        }.store(in: &cancellables)
    }
    
    func submit(onCompletion: @escaping () -> Void) {
        owner?.request(requester: { [weak self] () -> AnyPublisher<UserDetail, Error>? in
            guard let userDetailId = self?.user?.detail?.id,
                  let description = self?.description else {
                return nil
            }
            return self?.userDetailAPI.updateDescription(userDetailId: userDetailId, description: description)
        }) { _ in onCompletion() }?.store(in: &cancellables)
    }
}
