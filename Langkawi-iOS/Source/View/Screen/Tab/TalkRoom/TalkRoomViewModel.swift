//
//  TalkRoomViewModel.swift
//  Langkawi-iOS
//
//  Created by Yuki Matsuo on 2022/09/30.
//

import Combine

class TalkRoomViewModel: SwinjectSupport {
    private lazy var talkAPI = resolveInstance(TalkAPI.self)
    
    private weak var owner: OwnerVC?
    
    private var cancellables = Set<AnyCancellable>()
    
    @Published private var talkRoomsResponse: TalkRoomsResponse?
    
    var talkRooms = CurrentValueSubject<[TalkRoom], Never>([])
    
    init(owner: OwnerVC) {
        self.owner = owner
    }
    
    func setup() {
        owner?.useEffect { [weak self] in
            self?.owner?.request(requester: { self?.talkAPI.talkRooms(page: 0, pageSize: 100) }) {
                self?.talkRoomsResponse = $0
            }
        }
        
        $talkRoomsResponse.sink { [weak self] in
            guard let talkRooms = $0?.list else {
                return
            }
            self?.talkRooms.send(talkRooms)
        }.store(in: &cancellables)
    }
}
