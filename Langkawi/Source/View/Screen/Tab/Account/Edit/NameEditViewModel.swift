//
//  NameEditViewModel.swift
//  Langkawi-iOS
//
//  Created by Yuki Matsuo on 2022/09/27.
//

import Combine

class NameEditViewModel: SwinjectSupport {
    private lazy var userAPI = resolveInstance(UserAPI.self)
    
    private weak var owner: OwnerVC?
    
    @Published private var user: User?
    @Published var firstName: String?
    @Published var lastName: String?
    @Published var age: Int?
    @Published var gender: GenderType?
    
    private var cancellables = Set<AnyCancellable>()
    
    init(owner: OwnerVC) {
        self.owner = owner
    }
    
    func setup() {
        owner?.useEffect { [weak self] in
            self?.owner?.request(requester: { () -> AnyPublisher<User, Error>? in
                guard let userId = LoginSessionManager.getLoginUserId() else {
                    return nil
                }
                return self?.userAPI.user(userId: userId)
            }) {
                self?.user = $0
            }
        }
        
        $user.sink { [weak self] in
            guard let user = $0 else {
                return
            }
            
            self?.firstName = user.firstName
            self?.lastName = user.lastName
            self?.age = user.age
            self?.gender = user.gender
        }.store(in: &cancellables)
    }
    
    func submit(onComplete: @escaping () -> Void) {
        owner?.request(requester: { [weak self] () -> AnyPublisher<User, Error>? in
            guard let userId = LoginSessionManager.getLoginUserId() else {
                return nil
            }
            return self?.userAPI.updateUser(
                userId: userId,
                firstName: self?.firstName,
                lastName: self?.lastName,
                age: self?.age,
                gender: self?.gender
            )
        }) { _ in onComplete() }?.store(in: &cancellables)
    }
}
