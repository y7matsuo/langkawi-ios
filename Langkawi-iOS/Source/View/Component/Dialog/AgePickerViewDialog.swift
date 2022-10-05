//
//  AgePickerViewDialog.swift
//  Langkawi-iOS
//
//  Created by Yuki Matsuo on 2022/09/27.
//

import UIKit

struct AgePickerViewDialogSelectedData {
    let data: Int
}

class AgePickerViewDialog: PickerViewDialog<Int, AgePickerViewDialogSelectedData> {
    
    override var data: [Int] {
        return Array(18..<100)
    }
    
    override func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: String(data[row]), attributes: [.font: UIFont.systemFont(ofSize: 20)])
    }
    
    override func createSelectedData(row: Int) -> AgePickerViewDialogSelectedData {
        return AgePickerViewDialogSelectedData(data: data[row])
    }
}
