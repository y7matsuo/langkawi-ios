//
//  UserCell.swift
//  Langkawi-iOS
//
//  Created by Yuki Matsuo on 2022/09/14.
//

import UIKit
import Combine

open class UserCell: UICollectionViewCell, SwinjectSupport {
    
    private lazy var imageAPI = resolveInstance(ImageAPI.self)
    
    @Published var user: User?
    @Published var image: UIImage?
    
    weak var apiHandler: APIHandler?
    
    private var cancellables: Set<AnyCancellable> = []
    
    var imageView: UIImageView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
        subscribe()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("not implemented")
    }
    
    private func layout() {
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.gray.cgColor
        contentView.layer.cornerRadius = 5
        
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        
        contentView.addSubviewForAutoLayout(image)
        
        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: contentView.topAnchor),
            image.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            image.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            image.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.8)
        ])
        
        self.imageView = image
        
        layoutFooter()
    }
    
    func layoutFooter() {
    }
    
    func sinkUser(user: User) {
    }
    
    private func subscribe() {
        $user.sink { [weak self] in
            guard let user = $0 else {
                return
            }
            self?.sinkUser(user: user)
        }.store(in: &cancellables)
        
        $user.sink { [weak self] in
            guard let self = self,
                  let apiHandler = self.apiHandler,
                  let user = $0 else {
                return
            }
            
            apiHandler.request(requester: {
                self.imageAPI.getUserDetailPictureA(userId: user.id)
            }) {
                self.image = $0
            }?.store(in: &self.cancellables)
        }.store(in: &cancellables)
        
        $image.sink { [weak self] in
            guard let image = $0,
                  let imageView = self?.imageView else {
                return
            }
            imageView.image = image
        }.store(in: &cancellables)
    }
}
