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
