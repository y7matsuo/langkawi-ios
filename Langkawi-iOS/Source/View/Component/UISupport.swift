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
