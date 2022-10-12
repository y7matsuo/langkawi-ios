//
//  ProjectTextField.swift
//  Langkawi-iOS
//
//  Created by Yuki Matsuo on 2022/09/04.
//

import Foundation
import UIKit

class ProjectTextField: UITextField {
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }
}

class PasswordTextField: ProjectTextField {
    private var titleForSecure: NSAttributedString!
    private var titleForUnsecure: NSAttributedString!
    private var secureButton: UIButton!
    
    private var secureButtonTitle: NSAttributedString {
        return self.isSecureTextEntry ? titleForSecure : titleForUnsecure
    }
    
    init() {
        super.init(frame: .zero)
        self.isSecureTextEntry = true
        layoutSecureButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layoutSecureButton() {
        guard let font = UIFont.fontAwesome(type: .solid, size: 18) else {
            return
        }
        self.titleForSecure = NSAttributedString(string: "eye", attributes: [.font: font])
        self.titleForUnsecure = NSAttributedString(string: "eye-slash", attributes: [.font: font])
        
        secureButton = UIButton()
        secureButton.setAttributedTitle(titleForSecure, for: .normal)
        secureButton.setTitleColor(.white, for: .normal)
        secureButton.addAction(UIAction { [weak self] _ in
            self?.isSecureTextEntry.toggle()
            self?.secureButton.setAttributedTitle(self?.secureButtonTitle, for: .normal)
        }, for: .touchUpInside)
        secureButton.bounds.size = secureButton.intrinsicContentSize
        
        self.rightView = secureButton
        self.rightViewMode = .always
    }
    
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        let size = secureButton.intrinsicContentSize
        return bounds.inset(by: UIEdgeInsets(top: 0, left: bounds.size.width - size.width - 6, bottom: 0, right: 6))
    }
}
