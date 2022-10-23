//
//  RelatedUsersViewController.swift
//  Langkawi-iOS
//
//  Created by Yuki Matsuo on 2022/09/18.
//

import UIKit
import Combine

class RelatedUsersViewController: BaseViewController {
    lazy var vm = RelatedUsersViewModel(owner: self)
    
    private var registration: UICollectionView.CellRegistration<UserNameCell, Int>?
    
    var collectionView: UICollectionView?
    
    private var lookUpMoreAction: UIAction {
        return UIAction(title: "lookUpMore") { [weak self] _ in
            let vc = PositionStatusUsersViewController()
            vc.vm.positionStatus = self?.vm.positionStatus
            self?.navigationController?.pushViewController(vc, animated: false)
        }
    }
    
    override func viewDidLoad() {
        vm.setup()
        layout()
        super.viewDidLoad()
    }
    
    private func layout() {
        let headerView = UIStackView()
        headerView.axis = .horizontal
        headerView.distribution = .equalSpacing
        headerView.alignment = .center
        
        view.addSubviewForAutoLayout(headerView)
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 14),
            headerView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -14),
            headerView.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        titleLabel.text = vm.positionStatus?.string()
        
        let lookUpMoreButton = UIButton()
        let label = NSAttributedString(string: LabelDef.lookUpMore, attributes: [.font: UIFont.systemFont(ofSize: 12)])
        lookUpMoreButton.setAttributedTitle(label, for: .normal)
        lookUpMoreButton.setTitleColor(.blue, for: .normal)
        lookUpMoreButton.layer.borderWidth = 0
        lookUpMoreButton.addAction(lookUpMoreAction, for: .touchUpInside)
        
        headerView.addArrangedSubview(titleLabel)
        headerView.addArrangedSubview(lookUpMoreButton)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        
        self.registration = UICollectionView.CellRegistration<UserNameCell, Int> { [weak self] cell, _, itemIdentifier in
            guard let self = self, itemIdentifier < self.vm.users.count else {
                return
            }
            cell.apiHandler = self
            cell.user = self.vm.users[itemIdentifier]
        }
        
        view.addSubviewForAutoLayout(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        self.collectionView = collectionView
    }
}

extension RelatedUsersViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vm.users.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let registration = self.registration else {
            return UICollectionViewCell()
        }
        return collectionView.dequeueConfiguredReusableCell(using: registration, for: indexPath, item: indexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.bounds.height
        return CGSize(width: height * 0.83, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = UserDetailViewController()
        vc.vm.userId = vm.users[indexPath.item].id
        navigationController?.pushViewController(vc, animated: false)
    }
}
