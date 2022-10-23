//
//  RelatedUsersViewModel.swift
//  Langkawi-iOS
//
//  Created by Yuki Matsuo on 2022/09/18.
//

import Combine

class RelatedUsersViewModel: SwinjectSupport {
    var positionStatus: RelationPositionStatus?
    
    private lazy var relationApi = resolveInstance(RelationAPI.self)
    
    private weak var owner: RelatedUsersViewController?
    
    private var cancellables: Set<AnyCancellable> = []
    
    @Published var users: [User] = []
    
    init(owner: RelatedUsersViewController) {
        self.owner = owner
    }
    
    func setup() {
        owner?.useEffect(dependencies: [
            LoginSessionManager.loginSessionStored.eraseToAnyPublisher()
        ].compactMap { $0 }) { [weak self] in
            self?.fetch(size: 8)
        }
        
        $users.sink { [weak self] _ in
            self?.owner?.collectionView?.reloadData()
        }.store(in: &cancellables)
    }
    
    private func fetch(size: Int) -> AnyCancellable? {
        return owner?.request(requester: { [weak self] () -> AnyPublisher<RelationsResponse, Error>? in
            guard let positionStatus = self?.positionStatus else {
                return nil
            }
            return self?.relationApi.relations(page: 0, pageSize: size, positionStatus: positionStatus)
        }) { [weak self] in
            self?.users = $0.list.map { $0.user }
        }
    }
}
