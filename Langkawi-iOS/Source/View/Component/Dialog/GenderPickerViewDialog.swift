//
//  GenderPickerViewDialog.swift
//  Langkawi-iOS
//
//  Created by Yuki Matsuo on 2022/09/27.
//

import UIKit

struct GenderPickerViewDialogSelectedData {
    let data: GenderType
}

class GenederPickerViewDialog: PickerViewDialog<GenderType, GenderPickerViewDialogSelectedData> {
    
    override var data: [GenderType] {
        return GenderType.allCases
    }
    
    override func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: data[row].toLabel(), attributes: [.font: UIFont.systemFont(ofSize: 20)])
    }
    
    override func createSelectedData(row: Int) -> GenderPickerViewDialogSelectedData {
        return GenderPickerViewDialogSelectedData(data: data[row])
    }
}
