//
//  MainViewController.swift
//  Langkawi-iOS
//
//  Created by 松尾 勇気（Yuki Matsuo） on 2022/10/10.
//

import UIKit
import Combine

class MainViewController: UIViewController {
    private var blockScreen: UIView?
    
    private var cancellables = Set<AnyCancellable>()
    
    private var startSequenceResolvers = StartUitl.sequenceResolvers
    
    override func viewDidLoad() {
        layoutStartSequence()
        sink()
    }
    
    private func layoutStartSequence() {
        guard let rootResolver = startSequenceResolvers.first else {
            return
        }
        let sequenceVC = SequenceViewController(rootResolver: rootResolver) { [weak self] in
            $0.dismiss(animated: true)
            self?.removeVC()
            self?.layoutTabBar()
        }
        
        addChild(sequenceVC)
        view.addSubview(sequenceVC.view)
        sequenceVC.didMove(toParent: self)
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
    
    private func removeVC() {
        self.children.forEach {
            $0.view.removeFromSuperview()
            $0.removeFromParent()
        }
        
        self.view.subviews.forEach {
            $0.removeFromSuperview()
        }
    }
    
    private func sink() {
        LoginSessionManager.loginSessionStored.sink { [weak self] _ in
            self?.removeVC()
            self?.layoutTabBar()
        }.store(in: &cancellables)
    }
}

extension MainViewController {
    
    func showMenu() {
        let menuVC = MenuRouter.assemble()
        let vc = UINavigationController(rootViewController: menuVC)
        self.addChild(vc)
        self.view.addSubview(vc.view)
        vc.didMove(toParent: self)
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
