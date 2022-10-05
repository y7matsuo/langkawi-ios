//
//  UserIntroductionCell.swift
//  Langkawi-iOS
//
//  Created by Yuki Matsuo on 2022/09/18.
//

import UIKit

class UserIntroductionCell: UserCell {
    
    private var genderLabel: UILabel?
    private var ageLabel: UILabel?
    
    override func layoutFooter() {
        guard let imageView = self.imageView else {
            return
        }
        
        let attributeContainer = UIStackView()
        attributeContainer.axis = .horizontal
        attributeContainer.alignment = .center
        attributeContainer.distribution = .equalSpacing
        contentView.addSubviewForAutoLayout(attributeContainer)
        
        NSLayoutConstraint.activate([
            attributeContainer.topAnchor.constraint(equalTo: imageView.bottomAnchor),
            attributeContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            attributeContainer.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
            attributeContainer.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20)
        ])
        
        let gender = UILabel()
        gender.font = UIFont.systemFont(ofSize: 16)
        
        let age = UILabel()
        age.font = UIFont.systemFont(ofSize: 16)
        
        attributeContainer.addArrangedSubview(gender)
        attributeContainer.addArrangedSubview(age)
        
        self.genderLabel = gender
        self.ageLabel = age
    }
    
    override func sinkUser(user: User) {
        guard let genderLabel = self.genderLabel,
              let ageLabel = self.ageLabel else {
            return
        }
        
        genderLabel.text = user.gender?.toLabel()
        genderLabel.textColor = user.gender?.toColor()
        
        ageLabel.text = "\(user.age ?? 0)\(LabelDef.ageSuffix)"
        
        genderLabel.bounds.size = genderLabel.intrinsicContentSize
        ageLabel.bounds.size = ageLabel.intrinsicContentSize
    }
}
