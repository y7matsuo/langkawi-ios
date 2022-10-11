//
//  MainTabBarController.swift
//  Langkawi-iOS
//
//  Created by Yuki Matsuo on 2022/09/12.
//

import Foundation
import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewControllers()
        layoutTabBar()
    }
    
    private func setViewControllers() {
        if LoginSessionManager.getLoginUserId() != nil {
            viewControllers = viewControllersForLogin
        } else {
            viewControllers = viewControllersForLogout
        }
    }
    
    private var viewControllersForLogin: [UIViewController] {
        return [
            homeViewController,
            findViewController,
            talkRoomViewController,
            articleViewController,
            accountViewController
        ]
    }
    
    private var viewControllersForLogout: [UIViewController] {
        return [
            articleViewController
        ]
    }
    
    private var homeViewController: UIViewController {
        let vc = UINavigationController(rootViewController: HomeViewController())
        vc.tabBarItem = UITabBarItem(
            title: LabelDef.home,
            image: homeTabBarItemImage(color: .black),
            selectedImage: homeTabBarItemImage(color: .blue)
        )
        return vc
    }
    
    private var findViewController: UIViewController {
        let vc = UINavigationController(rootViewController: FindViewController())
        vc.tabBarItem = UITabBarItem(
            title: LabelDef.find,
            image: findTabBarItemImage(color: .black),
            selectedImage: findTabBarItemImage(color: .blue)
        )
        return vc
    }
    
    private var talkRoomViewController: UIViewController {
        let vc = UINavigationController(rootViewController: TalkRoomViewController())
        vc.tabBarItem = UITabBarItem(
            title: LabelDef.talkRoom,
            image: talkRoomTabBarItemImage(color: .black),
            selectedImage: talkRoomTabBarItemImage(color: .blue)
        )
        return vc
    }
    
    private var articleViewController: UIViewController {
        let vc = UINavigationController(rootViewController: ArticleViewController())
        vc.tabBarItem = UITabBarItem(
            title: LabelDef.article,
            image: articleTabBarItemImage(color: .black),
            selectedImage: articleTabBarItemImage(color: .blue)
        )
        return vc
    }
    
    private var accountViewController: UIViewController {
        let vc = UINavigationController(rootViewController: AccountRouter.assemble())
        vc.tabBarItem = UITabBarItem(
            title: LabelDef.account,
            image: accountTabBarItemImage(color: .black),
            selectedImage: accountTabBarItemImage(color: .blue)
        )
        return vc
    }
    
    private func layoutTabBar() {
        let border = UIView()
        border.backgroundColor = ColorDef.appBar
        
        tabBar.addSubviewForAutoLayout(border)
        
        NSLayoutConstraint.activate([
            border.topAnchor.constraint(equalTo: tabBar.topAnchor),
            border.leftAnchor.constraint(equalTo: tabBar.leftAnchor),
            border.rightAnchor.constraint(equalTo: tabBar.rightAnchor),
            border.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    private func tabBarItemImage(name: String, color: UIColor) -> UIImage? {
        let size: CGFloat = 20
        let label = UILabel.fontAwesome(type: .solid, name: name, color: color, size: size)
        label.bounds.size = CGSize(width: size+5, height: size)
        return label.toImage()
    }
    
    private func homeTabBarItemImage(color: UIColor) -> UIImage? {
        return tabBarItemImage(name: "house", color: color)
    }
    
    private func findTabBarItemImage(color: UIColor) -> UIImage? {
        return tabBarItemImage(name: "magnifying-glass", color: color)
    }
    
    private func talkRoomTabBarItemImage(color: UIColor) -> UIImage? {
        return tabBarItemImage(name: "comments", color: color)
    }
    
    private func articleTabBarItemImage(color: UIColor) -> UIImage? {
        return tabBarItemImage(name: "file-lines", color: color)
    }
    
    private func accountTabBarItemImage(color: UIColor) -> UIImage? {
        return tabBarItemImage(name: "user", color: color)
    }
}
