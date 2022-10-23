//
//  GenderType.swift
//  Langkawi-iOS
//
//  Created by Yuki Matsuo on 2022/09/14.
//

import Foundation
import UIKit

enum GenderType: String, Codable, CaseIterable {
    case male
    case female
    
    func toLabel() -> String {
        switch self {
        case .male:
            return LabelDef.male
        case .female:
            return LabelDef.female
        }
    }
    
    func toColor() -> UIColor {
        switch self {
        case .male:
            return .blue
        case .female:
            return .red
        }
    }
}
