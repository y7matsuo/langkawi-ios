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
