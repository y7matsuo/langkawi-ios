//
//  FontSupport.swift
//  Langkawi-iOS
//
//  Created by Yuki Matsuo on 2022/09/04.
//

import Foundation
import UIKit

enum FontAwesomeType: String {
    case regular = "FontAwesome6Free-Regular"
    case solid = "FontAwesome6Free-Solid"
    case brands = "FontAwesome6Brands-Regular"
}

extension UIFont {
    
    static func fontAwesome(type: FontAwesomeType, size: CGFloat) -> UIFont? {
        return UIFont(name: type.rawValue, size: size)
    }
}

extension UILabel {
    
    static func fontAwesome(type: FontAwesomeType, name: String, color: UIColor, size: CGFloat) -> UILabel {
        let label = UILabel()
        label.font = UIFont.fontAwesome(type: type, size: size)
        label.text = name
        label.textColor = color
        label.bounds.size = label.intrinsicContentSize
        return label
    }
}
