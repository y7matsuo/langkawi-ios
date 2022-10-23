//
//  TalkRoomCell.swift
//  Langkawi-iOS
//
//  Created by Yuki Matsuo on 2022/09/30.
//

import UIKit
import Combine

class TalkRoomCell: UITableViewCell, SwinjectSupport {
    private lazy var imageAPI = resolveInstance(ImageAPI.self)
    
    weak var owner: OwnerVC?
    
    @Published var talkRoom: TalkRoom?
    @Published private var avator: UIImage?
    
    private var avatorImageView: UIImageView?
    private var dateLabel: UILabel?
    private var nameLabel: UILabel?
    private var messageLabel: UILabel?
    
    private var cancellables = Set<AnyCancellable>()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        sink()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        self.avatorImageView = imageView
        
        contentView.addSubviewForAutoLayout(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor)
        ])
        
        let nameLabel = UILabel()
        nameLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        nameLabel.lineBreakMode = .byTruncatingTail
        self.nameLabel = nameLabel
        
        contentView.addSubviewForAutoLayout(nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: imageView.topAnchor),
            nameLabel.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 10),
            nameLabel.heightAnchor.constraint(equalToConstant: nameLabel.font.lineHeight)
        ])
        
        let dateLabel = UILabel()
        dateLabel.font = UIFont.systemFont(ofSize: 10)
        dateLabel.textColor = .gray
        self.dateLabel = dateLabel
        
        contentView.addSubviewForAutoLayout(dateLabel)
        NSLayoutConstraint.activate([
            dateLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
            dateLabel.bottomAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            dateLabel.heightAnchor.constraint(equalToConstant: dateLabel.font.lineHeight)
        ])
        
        let messageLabel = UILabel()
        messageLabel.font = UIFont.systemFont(ofSize: 12)
        messageLabel.textColor = .gray
        messageLabel.lineBreakMode = .byTruncatingTail
        messageLabel.numberOfLines = 2
        self.messageLabel = messageLabel
        
        contentView.addSubviewForAutoLayout(messageLabel)
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
            messageLabel.leftAnchor.constraint(equalTo: nameLabel.leftAnchor),
            messageLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
            messageLabel.bottomAnchor.constraint(lessThanOrEqualTo: imageView.bottomAnchor)
        ])
    }
    
    private func sink() {
        $talkRoom.sink { [weak self] in
            guard let self = self,
                  let talkRoom = $0 else {
                return
            }
            self.owner?.request(requester: { self.imageAPI.getUserDetailPictureA(userId: talkRoom.relation.user.id) }) {
                self.avator = $0
            }?.store(in: &self.cancellables)
        }.store(in: &cancellables)
        
        $avator.sink { [weak self] in
            self?.avatorImageView?.image = $0
        }.store(in: &cancellables)
        
        $talkRoom.sink { [weak self] in
            self?.nameLabel?.text = $0?.relation.user.toNameLabelText()
            self?.dateLabel?.text = $0?.lastTalk.updatedAt.toMMddHHmm()
            self?.messageLabel?.text = $0?.lastTalk.message
        }.store(in: &cancellables)
    }
}
