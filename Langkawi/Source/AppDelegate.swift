//
//  AppDelegate.swift
//
//  Created by Yuki Matsuo on 2022/10/23.
//  Copyright © 2022 y7matsuo. All rights reserved.
//

import UIKit

class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        SwinjectManager.shared.initialize()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = MainViewController()
        window?.rootViewController?.view.backgroundColor = .white
        window?.makeKeyAndVisible()

        return true
    }
}
