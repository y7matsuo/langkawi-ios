//
//  AccountViewModel.swift
//  Langkawi-iOS
//
//  Created by Yuki Matsuo on 2022/09/22.
//

import Combine

class AccountViewModel: SwinjectSupport {
    private lazy var userAPI = resolveInstance(UserAPI.self)
    private lazy var imageAPI = resolveInstance(ImageAPI.self)
    private lazy var userId = LoginTokenManager.getLoginUserId()
    
    private weak var owner: AccountViewController?
    
    init(owner: AccountViewController) {
        self.owner = owner
    }
    
    func setup() {
        guard let userId = userId else {
            return
        }

        owner?.useEffect { [weak self] in
            self?.owner?.request(requester: { self?.imageAPI.getUserDetailPictureA(userId: userId) }) {
                self?.owner?.avator?.image = $0
            }
        }
        
        owner?.useEffect { [weak self] in
            self?.owner?.request(requester: { self?.userAPI.user(userId: userId) }) {
                guard let owner = self?.owner else {
                    return
                }
                owner.nameLabel?.text = $0.toNameLabelText()
                owner.genderLabel?.text = $0.gender?.toLabel()
                owner.genderLabel?.textColor = $0.gender?.toColor()
                owner.ageLabel?.text = $0.toAgeLabelText()
                owner.descriptionLabel?.text = $0.detail?.descriptionA
            }
        }
    }
}
