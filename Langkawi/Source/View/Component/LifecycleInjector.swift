//
//  LifecycleInjector.swift
//  Langkawi-iOS
//
//  Created by Yuki Matsuo on 2022/09/15.
//

import UIKit

protocol LifecycleInjector {
    
    func onViewDidLoad()
    
    func onViewWillAppear()
    
    func onViewDidAppear()
    
    func onViewWillDisappear()
    
    func onViewDidDisappear()
}

extension LifecycleInjector {
    
    func onViewDidLoad() {}
    
    func onViewWillAppear() {}
    
    func onViewDidAppear() {}
    
    func onViewWillDisappear() {}
    
    func onViewDidDisappear() {}
}

class LifecycleInjectableViewController: UIViewController {
    
    private var lifecycleInjectors: [LifecycleInjector] = []
    
    func registerLifecycleInjector(injector: LifecycleInjector) {
        lifecycleInjectors.append(injector)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lifecycleInjectors.forEach { $0.onViewDidLoad() }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        lifecycleInjectors.forEach { $0.onViewWillAppear() }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        lifecycleInjectors.forEach { $0.onViewDidAppear() }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        lifecycleInjectors.forEach { $0.onViewWillDisappear() }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        lifecycleInjectors.forEach { $0.onViewDidDisappear() }
    }
}
