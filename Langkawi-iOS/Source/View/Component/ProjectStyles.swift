//
//  ProjectButtons.swift
//  Langkawi-iOS
//
//  Created by Yuki Matsuo on 2022/09/27.
//

import UIKit

class ProjectStyles {
    
    static func primaryButton(title: String, action: UIAction) -> UIButton {
        let button = UIButton()
        button.layer.cornerRadius = 20
        button.backgroundColor = .green
        button.setAttributedTitle(
            NSAttributedString(string: title, attributes: [.font: UIFont.systemFont(ofSize: 16, weight: .bold)]),
            for: .normal
        )
        button.addAction(action, for: .touchUpInside)
        return button
    }
}

extension UIButton {
    
    func configurePrimary(title: String, action: @escaping () -> Void) {
        self.configureDefault(title: title, action: action)
        self.backgroundColor = ColorDef.primary
    }
    
    func configureSecondary(title: String, action: @escaping () -> Void) {
        self.configureDefault(title: title, action: action)
        self.backgroundColor = ColorDef.secondary
    }
    
    private func configureDefault(title: String, action: @escaping () -> Void) {
        self.layer.cornerRadius = 25
        self.setAttributedTitle(
            NSAttributedString(string: title, attributes: [.font: UIFont.systemFont(ofSize: 16, weight: .bold)]),
            for: .normal
        )
        self.setTitleColor(.black, for: .normal)
        self.addAction(UIAction { _ in action() }, for: .touchUpInside)
    }
}
