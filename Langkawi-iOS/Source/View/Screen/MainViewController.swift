//
//  MainViewController.swift
//  Langkawi-iOS
//
//  Created by 松尾 勇気（Yuki Matsuo） on 2022/10/10.
//

import UIKit

class MainViewController: UIViewController {
    private var blockScreen: UIView?
    
    override func viewDidLoad() {
        layoutTabBar()
    }
    
    private func layoutTabBar() {
        let tabBarVC = MainTabBarController()
        addChild(tabBarVC)
        view.addSubviewForAutoLayout(tabBarVC.view)
        NSLayoutConstraint.activate([
            tabBarVC.view.topAnchor.constraint(equalTo: view.topAnchor),
            tabBarVC.view.leftAnchor.constraint(equalTo: view.leftAnchor),
            tabBarVC.view.rightAnchor.constraint(equalTo: view.rightAnchor),
            tabBarVC.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        tabBarVC.didMove(toParent: self)
    }
}

extension MainViewController {
    
    func showMenu() {
        let menuVC = MenuViewController()
        menuVC.beforeShow = { [weak self] in self?.addBlockScreen() }
        menuVC.afterResign = { [weak self] in self?.removeBlockScreen() }
        menuVC.show(parent: self)
    }
    
    func addBlockScreen() {
        let blockScreen = UIView()
        self.blockScreen = blockScreen
        blockScreen.backgroundColor = ColorDef.blockScreen
        
        view.addSubviewForAutoLayout(blockScreen)
        NSLayoutConstraint.activate([
            blockScreen.topAnchor.constraint(equalTo: view.topAnchor),
            blockScreen.leftAnchor.constraint(equalTo: view.leftAnchor),
            blockScreen.rightAnchor.constraint(equalTo: view.rightAnchor),
            blockScreen.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func removeBlockScreen() {
        self.blockScreen?.removeFromSuperview()
    }
}
