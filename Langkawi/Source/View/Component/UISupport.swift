//
//  UISupport.swift
//  Langkawi-iOS
//
//  Created by Yuki Matsuo on 2022/09/04.
//

import Foundation
import UIKit

extension UIView {
    
    func addSubviewForAutoLayout(_ view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(view)
    }
    
    func layoutFit(_ view: UIView) {
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: self.topAnchor),
            view.leftAnchor.constraint(equalTo: self.leftAnchor),
            view.rightAnchor.constraint(equalTo: self.rightAnchor),
            view.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}

extension UILabel {
    
    func toImage() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, 0)
        defer { UIGraphicsEndImageContext() }
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        self.layer.render(in: context)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}

extension UIViewController {
    func layoutNavigationBarBorder() {
        let border = UIView()
        border.backgroundColor = .lightGray
        
        guard let navigationBar = navigationController?.navigationBar else {
            return
        }
        
        navigationBar.addSubviewForAutoLayout(border)
        
        NSLayoutConstraint.activate([
            border.heightAnchor.constraint(equalToConstant: 1),
            border.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor),
            border.leftAnchor.constraint(equalTo: navigationBar.leftAnchor),
            border.rightAnchor.constraint(equalTo: navigationBar.rightAnchor)
        ])
    }
}

extension UIViewController {
    
    func addMenuButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UILabel.fontAwesome(type: .solid, name: "bars", color: .black, size: 20).toImage() ?? UIImage(),
            style: .plain,
            target: self,
            action: #selector(self.onTapMenuButton(_:))
        )
        navigationItem.rightBarButtonItem?.tintColor = .black
        setScreenEdgePanGestureRecognizerForMenu()
    }
    
    private func setScreenEdgePanGestureRecognizerForMenu() {
        let recognizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(self.onScreenEdgePanGestureForMenu(_:)))
        recognizer.edges = .left
        view.addGestureRecognizer(recognizer)
    }
    
    @objc private func onTapMenuButton(_ sender: UIBarButtonItem) {
        showMenuView()
    }
    
    @objc private func onScreenEdgePanGestureForMenu(_ sender: UIScreenEdgePanGestureRecognizer) {
        let translation = sender.translation(in: self.view)
        
        if sender.state == .began && translation.x > 0 {
            showMenuView()
        }
    }
    
    private func showMenuView() {
        guard let vc = resolveMainViewController() else {
            return
        }
        vc.showMenu()
    }
    
    private func resolveMainViewController() -> MainViewController? {
        var vc: UIViewController? = self
        repeat {
            if let menuShowable = vc as? MainViewController {
                return menuShowable
            }
            vc = vc?.parent
        } while vc != nil
        return nil
    }
}

extension UIViewController {
    
    func resolveSequenceSupport() -> SequenceSupport? {
        return parent as? SequenceSupport
    }
}
