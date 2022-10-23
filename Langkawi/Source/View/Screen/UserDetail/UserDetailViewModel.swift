//
//  UserDetailViewModel.swift
//  Langkawi-iOS
//
//  Created by Yuki Matsuo on 2022/09/21.
//

import Combine
import UIKit

class UserDetailViewModel: SwinjectSupport {
    private lazy var relationAPI = resolveInstance(RelationAPI.self)
    private lazy var userAPI = resolveInstance(UserAPI.self)
    private lazy var imageAPI = resolveInstance(ImageAPI.self)
    
    var userId: Int?
    
    private weak var owner: UserDetailViewController?
    
    @Published private var user: User?
    
    @Published private var positionStatus: RelationPositionStatus?
    
    @Published private var nextStatuses: [RelationStatus]?
    
    @Published private var avator: UIImage?
    
    private var noRelation = CurrentValueSubject<Bool, Never>(false)
    
    private var cancellables: Set<AnyCancellable> = []
    
    struct ButtonAttrs {
        let title: String
        let color: UIColor
        let action: UIAction
    }
    
    init(owner: UserDetailViewController) {
        self.owner = owner
    }
    
    func setup() {
        owner?.useEffect { [weak self] in
            self?.owner?.request(errorHandler: {
                guard let error = $0 as? APIStatusError, error.status == 404 else {
                    return true
                }
                self?.noRelation.send(true)
                return false
            }, requester: { () -> AnyPublisher<RelationResponse, Error>? in
                guard let userId = self?.userId else {
                    return nil
                }
                return self?.relationAPI.relation(userId: userId)
            }) {
                self?.user = $0.user
                self?.positionStatus = $0.positionStatus
                self?.nextStatuses = $0.nextStatuses
                self?.noRelation.send(false)
            }
        }
        
        owner?.useEffect { [weak self] in
            self?.owner?.request(requester: { () -> AnyPublisher<UIImage, Error>? in
                guard let userId = self?.userId else {
                    return nil
                }
                return self?.imageAPI.getUserDetailPictureA(userId: userId)
            }) {
                self?.avator = $0
            }
        }
        
        owner?.useEffect(dependencies: [noRelation.eraseToAnyPublisher()]) { [weak self] in
            guard let userId = self?.userId, self?.noRelation.value == true else {
                return nil
            }
            return self?.owner?.request(requester: { self?.userAPI.user(userId: userId) }) {
                self?.user = $0
                self?.nextStatuses = nil
            }
        }
        
        $user.sink { [weak self] in
            guard let user = $0,
                  let owner = self?.owner else {
                return
            }
            owner.nameLabel?.text = user.toNameLabelText()
            owner.genderLabel?.text = user.gender?.toLabel()
            owner.genderLabel?.textColor = user.gender?.toColor()
            owner.ageLabel?.text = user.toAgeLabelText()
            owner.descriptionLabel?.text = user.detail?.descriptionA
        }.store(in: &cancellables)
        
        $avator.sink { [weak self] in
            self?.owner?.avator?.image = $0
        }.store(in: &cancellables)
        
        $positionStatus.sink { [weak self] in
            self?.owner?.statusLabel?.text = $0?.string()
        }.store(in: &cancellables)
        
        $nextStatuses.sink { [weak self] in
            guard let view = self?.owner?.view,
                  let buttonAttrs = self?.buttonAttrs(statuses: $0) else {
                return
            }
            
            self?.owner?.layoutButtons(attrs: buttonAttrs)
            view.setNeedsLayout()
            view.layoutIfNeeded()
        }.store(in: &cancellables)
    }
    
    private func buttonAttrs(statuses: [RelationStatus]?) -> [ButtonAttrs] {
        if let statuses = statuses {
            return statuses.enumerated().map { status in
                ButtonAttrs(
                    title: status.element.toButtonTitle(),
                    color: status.offset == 0 ? .orange : .purple,
                    action: UIAction { [weak self] _ in
                        guard let userId = self?.userId else {
                            return
                        }
                        self?.showConfirmDialog(message: status.element.toConfirmMessage()) {
                            self?.relationAPI.updateRelation(userId: userId, status: status.element)
                        }
                    }
                )
            }
        }
        return [
            ButtonAttrs(title: LabelDef.apply, color: .green, action: UIAction { [weak self] _ in
                guard let userId = self?.userId else {
                    return
                }
                self?.showConfirmDialog(message: MessageDef.confirmPending) {
                    self?.relationAPI.createRelation(userId: userId)
                }
            })
        ]
    }
    
    private func showConfirmDialog<T>(message: String, requester: @escaping () -> AnyPublisher<T, Error>?) {
        DialogManager.showAlert(
            vc: self.owner,
            title: nil,
            message: message,
            ok: UIAlertAction(title: LabelDef.ok, style: .default) { [weak self] _ in
                guard let self = self else {
                    return
                }
                self.owner?.request(requester: requester) { _ in }?.store(in: &self.cancellables)
                self.owner?.navigationController?.popViewController(animated: true)
            },
            cancel: UIAlertAction(title: LabelDef.cancel, style: .cancel)
        )
    }
}
