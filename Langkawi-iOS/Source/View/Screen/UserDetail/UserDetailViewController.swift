//
//  UserDetailViewController.swift
//  Langkawi-iOS
//
//  Created by Yuki Matsuo on 2022/09/21.
//

import UIKit

class UserDetailViewController: BaseViewController {
    lazy var vm = UserDetailViewModel(owner: self)
    
    var avator: UIImageView?
    var nameLabel: UILabel?
    var genderLabel: UILabel?
    var ageLabel: UILabel?
    var statusLabel: UILabel?
    var descriptionLabel: UILabel?
    
    override func viewDidLoad() {
        vm.setup()
        layout()
        super.viewDidLoad()
    }
    
    private func layout() {
        let headerContainer = UIStackView()
        headerContainer.axis = .horizontal
        headerContainer.alignment = .fill
        headerContainer.distribution = .fillEqually
        
        view.addSubviewForAutoLayout(headerContainer)
        NSLayoutConstraint.activate([
            headerContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            headerContainer.leftAnchor.constraint(equalTo: view.leftAnchor),
            headerContainer.rightAnchor.constraint(equalTo: view.rightAnchor),
            headerContainer.heightAnchor.constraint(equalToConstant: 180)
        ])
        
        let avator = UIImageView()
        avator.contentMode = .scaleAspectFit
        self.avator = avator
        headerContainer.addArrangedSubview(avator)
        
        let attrsView = UIStackView()
        attrsView.axis = .vertical
        attrsView.distribution = .equalSpacing
        attrsView.alignment = .fill
        headerContainer.addArrangedSubview(attrsView)
        
        let nameLabel = UILabel()
        nameLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        self.nameLabel = nameLabel
        
        let genderLabel = UILabel()
        genderLabel.font = UIFont.systemFont(ofSize: 18)
        self.genderLabel = genderLabel
        
        let ageLabel = UILabel()
        ageLabel.font = UIFont.systemFont(ofSize: 18)
        self.ageLabel = ageLabel
        
        let statusLabel = UILabel()
        statusLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        statusLabel.adjustsFontSizeToFitWidth = true
        self.statusLabel = statusLabel
        
        attrsView.addArrangedSubview(nameLabel)
        attrsView.addArrangedSubview(genderLabel)
        attrsView.addArrangedSubview(ageLabel)
        attrsView.addArrangedSubview(statusLabel)
        
        let descriptionLabel = UILabel()
        descriptionLabel.font = UIFont.systemFont(ofSize: 14)
        descriptionLabel.numberOfLines = 0
        self.descriptionLabel = descriptionLabel
        
        view.addSubviewForAutoLayout(descriptionLabel)
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: headerContainer.bottomAnchor, constant: 16),
            descriptionLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
            descriptionLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10)
        ])
    }
    
    func layoutButtons(attrs: [UserDetailViewModel.ButtonAttrs]) {
        var neighbor: UIButton?
        attrs.enumerated().forEach {
            let button = layoutButton(attr: $0.element)
            view.addSubviewForAutoLayout(button)
            
            NSLayoutConstraint.activate([
                button.widthAnchor.constraint(equalToConstant: 240),
                button.heightAnchor.constraint(equalToConstant: 40),
                button.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ])
            
            if let neighbor = neighbor {
                button.topAnchor.constraint(equalTo: neighbor.bottomAnchor, constant: 16).isActive = true
            }
            if $0.offset == attrs.endIndex - 1 {
                button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24).isActive = true
            }
            neighbor = button
        }
    }
    
    private func layoutButton(attr: UserDetailViewModel.ButtonAttrs) -> UIButton {
        let button = UIButton()
        button.setAttributedTitle(
            NSAttributedString(string: attr.title, attributes: [.font: UIFont.systemFont(ofSize: 16, weight: .bold)]),
            for: .normal
        )
        button.backgroundColor = attr.color
        button.addAction(attr.action, for: .touchUpInside)
        button.layer.borderWidth = 0
        button.layer.cornerRadius = 20
        return  button
    }
}
