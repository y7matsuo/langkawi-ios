//
//  PositionStatusUsersViewController.swift
//  Langkawi-iOS
//
//  Created by Yuki Matsuo on 2022/09/20.
//

import UIKit

class PositionStatusUsersViewController: BaseViewController {
    lazy var vm = PositionStatusUsersViewModel()
    
    override func viewDidLoad() {
        layoutNavigationBar()
        layout()
        super.viewDidLoad()
    }
    
    private func layoutNavigationBar() {
        navigationItem.title = vm.positionStatus?.string()
        navigationItem.backButtonTitle = LabelDef.back
    }
    
    private func layout() {
        let vc = UsersViewController<UserNameCell>()
        vc.registerRequester(requester: vm.requester)
        self.addChild(vc)
        vc.didMove(toParent: self)
        
        view.addSubviewForAutoLayout(vc.view)
        NSLayoutConstraint.activate([
            vc.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            vc.view.leftAnchor.constraint(equalTo: view.leftAnchor),
            vc.view.rightAnchor.constraint(equalTo: view.rightAnchor),
            vc.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
