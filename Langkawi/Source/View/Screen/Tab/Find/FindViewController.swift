//
//  FindViewController.swift
//  Langkawi-iOS
//
//  Created by Yuki Matsuo on 2022/09/20.
//

import UIKit

class FindViewController: BaseViewController {
    private lazy var vm = FindViewModel()
    
    override func viewDidLoad() {
        layoutNavigationBar()
        layout()
        super.viewDidLoad()
    }
    
    private func layoutNavigationBar() {
        navigationItem.title = LabelDef.find
        navigationItem.backButtonTitle = LabelDef.back
        addMenuButton()
        layoutNavigationBarBorder()
    }
    
    private func layout() {
        let usersVC = UsersViewController<UserIntroductionCell>()
        usersVC.registerRequester(requester: vm.requester)
        self.addChild(usersVC)
        usersVC.didMove(toParent: self)
        
        view.addSubviewForAutoLayout(usersVC.view)
        NSLayoutConstraint.activate([
            usersVC.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            usersVC.view.leftAnchor.constraint(equalTo: view.leftAnchor),
            usersVC.view.rightAnchor.constraint(equalTo: view.rightAnchor),
            usersVC.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
