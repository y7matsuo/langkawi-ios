//
//  UserNameCell.swift
//  Langkawi-iOS
//
//  Created by Yuki Matsuo on 2022/09/18.
//

import UIKit

class UserNameCell: UserCell {
    
    private var nameLabel: UILabel?
    
    override func layoutFooter() {
        guard let imageView = self.imageView else {
            return
        }
        
        let container = UIView()
        contentView.addSubviewForAutoLayout(container)
        
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: imageView.bottomAnchor),
            container.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            container.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        let name = UILabel()
        name.font = UIFont.systemFont(ofSize: 16)
        
        container.addSubviewForAutoLayout(name)
        
        NSLayoutConstraint.activate([
            name.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            name.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])
        
        self.nameLabel = name
    }
    
    override func sinkUser(user: User) {
        guard let nameLabel = nameLabel else {
            return
        }
        nameLabel.text = user.toNameLabelText()
        nameLabel.bounds.size = nameLabel.intrinsicContentSize
    }
}
