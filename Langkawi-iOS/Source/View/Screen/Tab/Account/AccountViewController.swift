//
//  AccountViewController.swift
//  Langkawi-iOS
//
//  Created by Yuki Matsuo on 2022/09/22.
//

import UIKit

class AccountViewController: BaseViewController {
    private lazy var vm = AccountViewModel(owner: self)
    
    var avator: UIImageView?
    var nameLabel: UILabel?
    var genderLabel: UILabel?
    var ageLabel: UILabel?
    var descriptionLabel: UILabel?
    
    private var nameArea: UIView?
    
    override func viewDidLoad() {
        vm.setup()
        layoutNavigationBar()
        layoutImageContainer()
        layoutNameArea()
        layoutDescriptionArea()
        super.viewDidLoad()
    }
    
    private func layoutNavigationBar() {
        navigationItem.title = LabelDef.account
        navigationItem.backButtonTitle = LabelDef.back
        layoutNavigationBarBorder()
    }
    
    private func layoutImageContainer() {
        let avator = UIImageView()
        avator.contentMode = .scaleAspectFit
        self.avator = avator
        
        view.addSubviewForAutoLayout(avator)
        NSLayoutConstraint.activate([
            avator.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            avator.leftAnchor.constraint(equalTo: view.leftAnchor),
            avator.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            avator.heightAnchor.constraint(equalToConstant: 180)
        ])
        
        layoutEditButton(leftContainer: avator, name: "images", type: .regular) { _ in }
    }
    
    private func layoutNameArea() {
        guard let avator = avator else {
            return
        }

        let nameArea = UIView()
        nameArea.layer.borderColor = UIColor.lightGray.cgColor
        nameArea.layer.borderWidth = 1
        nameArea.layer.cornerRadius = 10
        self.nameArea = nameArea
        
        view.addSubviewForAutoLayout(nameArea)
        NSLayoutConstraint.activate([
            nameArea.topAnchor.constraint(equalTo: avator.bottomAnchor, constant: 15),
            nameArea.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
            nameArea.rightAnchor.constraint(equalTo: avator.rightAnchor),
            nameArea.heightAnchor.constraint(equalToConstant: 120)
        ])
        
        let nameAreaStack = UIStackView()
        nameAreaStack.axis = .vertical
        nameAreaStack.distribution = .equalSpacing
        nameAreaStack.alignment = .leading
        
        nameArea.addSubviewForAutoLayout(nameAreaStack)
        NSLayoutConstraint.activate([
            nameAreaStack.topAnchor.constraint(equalTo: nameArea.topAnchor, constant: 10),
            nameAreaStack.leftAnchor.constraint(equalTo: nameArea.leftAnchor, constant: 8),
            nameAreaStack.rightAnchor.constraint(equalTo: nameArea.rightAnchor),
            nameAreaStack.bottomAnchor.constraint(equalTo: nameArea.bottomAnchor, constant: -10)
        ])
        
        let nameLabel = UILabel()
        nameLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        self.nameLabel = nameLabel
        
        let genderLabel = UILabel()
        genderLabel.font = UIFont.systemFont(ofSize: 18)
        self.genderLabel = genderLabel
        
        let ageLabel = UILabel()
        ageLabel.font = UIFont.systemFont(ofSize: 18)
        self.ageLabel = ageLabel
        
        nameAreaStack.addArrangedSubview(nameLabel)
        nameAreaStack.addArrangedSubview(genderLabel)
        nameAreaStack.addArrangedSubview(ageLabel)
        
        layoutEditButton(leftContainer: nameArea, name: "pen-to-square", type: .solid) { [weak self] _ in
            self?.navigationController?.pushViewController(NameEditViewController(), animated: false)
        }
    }
    
    private func layoutDescriptionArea() {
        guard let nameArea = nameArea else {
            return
        }
        
        let descriptionLabel = UILabel()
        descriptionLabel.font = UIFont.systemFont(ofSize: 14)
        descriptionLabel.numberOfLines = 0
        self.descriptionLabel = descriptionLabel
        
        view.addSubviewForAutoLayout(descriptionLabel)
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: nameArea.bottomAnchor, constant: 15),
            descriptionLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
            descriptionLabel.rightAnchor.constraint(equalTo: nameArea.rightAnchor),
            descriptionLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 40)
        ])
        
        layoutEditButton(leftContainer: descriptionLabel, name: "pencil", type: .solid) { [weak self] _ in
            self?.navigationController?.pushViewController(DescriptionEditViewController(), animated: false)
        }
    }
    
    private func layoutEditButton(leftContainer: UIView, name: String, type: FontAwesomeType, handler: @escaping UIActionHandler) {
        let button = UIButton()
        button.addAction(UIAction(handler: handler), for: .touchUpInside)
        button.backgroundColor = .lightGray
        button.layer.borderWidth = 0
        button.layer.cornerRadius = 20
        
        if let font = UIFont.fontAwesome(type: .solid, size: 25) {
            button.setAttributedTitle(
                NSAttributedString(string: name, attributes: [.font: font]),
                for: .normal
            )
        }
        
        let rightContainer = UIView()
        view.addSubviewForAutoLayout(rightContainer)
        NSLayoutConstraint.activate([
            rightContainer.topAnchor.constraint(equalTo: leftContainer.topAnchor),
            rightContainer.leftAnchor.constraint(equalTo: leftContainer.rightAnchor),
            rightContainer.rightAnchor.constraint(equalTo: view.rightAnchor),
            rightContainer.bottomAnchor.constraint(equalTo: leftContainer.bottomAnchor)
        ])
        
        rightContainer.addSubviewForAutoLayout(button)
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: rightContainer.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: rightContainer.centerYAnchor),
            button.widthAnchor.constraint(equalToConstant: 40),
            button.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}
