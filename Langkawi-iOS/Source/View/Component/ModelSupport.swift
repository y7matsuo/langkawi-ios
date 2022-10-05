//
//  ModelSupport.swift
//  Langkawi-iOS
//
//  Created by Yuki Matsuo on 2022/09/30.
//

import Foundation

extension User {
    
    func toNameLabelText() -> String {
        return "\(self.lastName ?? "") \(self.firstName ?? "")"
    }
    
    func toAgeLabelText() -> String {
        return "\(self.age ?? 0)\(LabelDef.ageSuffix)"
    }
}

extension Date {
    
    func toMMddHHmm() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd HH:mm"
        return formatter.string(from: self)
    }
}
