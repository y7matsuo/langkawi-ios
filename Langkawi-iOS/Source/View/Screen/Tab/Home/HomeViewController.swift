//
//  HomeViewController.swift
//  Langkawi-iOS
//
//  Created by Yuki Matsuo on 2022/08/30.
//

import UIKit
import Combine

class HomeViewController: BaseViewController {
    private var containerView: UIView?
    
    override func viewDidLoad() {
        layoutNavigationBar()
        layout()
        super.viewDidLoad()
    }
    
    private func layoutNavigationBar() {
        navigationItem.title = LabelDef.home
        navigationItem.backButtonTitle = LabelDef.back
        layoutNavigationBarBorder()
    }
    
    private func layout() {
        let collectionViewHeight: CGFloat = 136
        let verticalMargin: CGFloat = 30
        
        let viewControllers: [RelatedUsersViewController] = RelationPositionStatus.allCases.map { [weak self] in
            let vc = RelatedUsersViewController()
            vc.vm.positionStatus = $0
            self?.addChild(vc)
            vc.didMove(toParent: self)
            return vc
        }
        
        let scrollView = UIScrollView()
        scrollView.isScrollEnabled = true
        
        view.addSubviewForAutoLayout(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: view.rightAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        let container = UIView()
        scrollView.addSubviewForAutoLayout(container)
        
        let height = collectionViewHeight + verticalMargin
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: scrollView.topAnchor),
            container.leftAnchor.constraint(equalTo: scrollView.leftAnchor),
            container.rightAnchor.constraint(equalTo: scrollView.rightAnchor),
            container.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            container.widthAnchor.constraint(equalTo: view.widthAnchor),
            container.heightAnchor.constraint(equalToConstant: height * CGFloat(viewControllers.count))
        ])
        
        self.containerView = container
        
        var anchor = container.topAnchor
        viewControllers.forEach {
            container.addSubviewForAutoLayout($0.view)
            NSLayoutConstraint.activate([
                $0.view.topAnchor.constraint(equalTo: anchor, constant: verticalMargin),
                $0.view.leftAnchor.constraint(equalTo: container.leftAnchor),
                $0.view.rightAnchor.constraint(equalTo: container.rightAnchor),
                $0.view.heightAnchor.constraint(equalToConstant: collectionViewHeight)
            ])
            anchor = $0.view.bottomAnchor
        }
    }
}

