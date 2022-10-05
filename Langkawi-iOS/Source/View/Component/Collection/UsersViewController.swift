//
//  UsersViewController.swift
//  Langkawi-iOS
//
//  Created by Yuki Matsuo on 2022/09/14.
//

import Foundation
import UIKit
import Combine

class UsersViewController<T: UserCell>: BaseViewController,
                                        UICollectionViewDataSource,
                                        UICollectionViewDelegateFlowLayout {
    
    private lazy var vm = UsersViewModel(owner: self)
    
    private var cellRegistration: UICollectionView.CellRegistration<T, Int>?
    
    var collectionView: UICollectionView?
    
    func registerRequester(requester: @escaping UsersViewModel<T>.Requester) {
        vm.requester = requester
    }
    
    override func viewDidLoad() {
        vm.setup()
        layout()
        super.viewDidLoad()
    }
    
    private func layout() {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.delegate = self
        collectionView.dataSource = self
        
        cellRegistration = UICollectionView.CellRegistration<T, Int> { [weak self] cell, _, itemIdentifier in
            cell.apiHandler = self
            cell.user = self?.vm.resolveUser(index: itemIdentifier)
        }
        
        view.addSubviewForAutoLayout(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
        
        self.collectionView = collectionView
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vm.resolveCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cellRegistration = cellRegistration else {
            return UICollectionViewCell()
        }

        return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: indexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 30) / 3
        let height = width * 1.2
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 0, right: 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = UserDetailViewController()
        vc.vm.userId = vm.resolveUser(index: indexPath.item)?.id
        navigationController?.pushViewController(vc, animated: false)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // TODO: fetch another page
    }
}
