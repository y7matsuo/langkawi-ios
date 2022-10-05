//
//  PickerViewDialog.swift
//  Langkawi-iOS
//
//  Created by Yuki Matsuo on 2022/09/27.
//

import UIKit

open class PickerViewDialog<T: Equatable, U>: UIViewController, DialogPresentedSupport, UIPickerViewDelegate, UIPickerViewDataSource {
    var parentVC: DialogPresenterSupport?
    
    var initialSelected: T?
    
    private var pickerView: UIPickerView?
    
    open var data: [T] {
        return []
    }
    
    override open func viewDidLoad() {
        layout()
        super.viewDidLoad()
    }
    
    private func layout() {
        view.backgroundColor = .clear
        
        let pickerView = UIPickerView()
        pickerView.backgroundColor = .white
        pickerView.delegate = self
        pickerView.dataSource = self
        self.pickerView = pickerView
        
        view.addSubviewForAutoLayout(pickerView)
        NSLayoutConstraint.activate([
            pickerView.leftAnchor.constraint(equalTo: view.leftAnchor),
            pickerView.rightAnchor.constraint(equalTo: view.rightAnchor),
            pickerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        let selectedIndex = data.firstIndex { $0 == initialSelected }
        if let selectedIndex = selectedIndex {
            pickerView.selectRow(selectedIndex, inComponent: 0, animated: false)
        }
        
        layoutButton(title: LabelDef.submit, color: .green, xaxisMargin: -10) { [weak self] in
            guard let row = self?.pickerView?.selectedRow(inComponent: 0),
                  let selected = self?.createSelectedData(row: row) else {
                return
            }
            self?.sendDialogEventAndDismiss(event: .userDefined(content: selected))
        }
        
        layoutButton(title: LabelDef.cancel, color: .purple, xaxisMargin: 10) { [weak self] in
            self?.sendDialogEventAndDismiss(event: .cancel)
        }
    }
    
    private func layoutButton(title: String, color: UIColor, xaxisMargin: CGFloat, onClick: @escaping () -> Void) {
        guard let pickerView = pickerView else {
            return
        }

        let button = UIButton()
        button.layer.cornerRadius = 15
        button.backgroundColor = color
        button.setAttributedTitle(NSAttributedString(string: title, attributes: [.font: UIFont.systemFont(ofSize: 16, weight: .bold)]), for: .normal)
        button.addAction(UIAction { _ in onClick() }, for: .touchUpInside)
        
        view.addSubviewForAutoLayout(button)
        
        let yAnchor = xaxisMargin > 0 ? button.leftAnchor : button.rightAnchor
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 140),
            button.heightAnchor.constraint(equalToConstant: 30),
            yAnchor.constraint(equalTo: view.centerXAnchor, constant: xaxisMargin),
            button.bottomAnchor.constraint(equalTo: pickerView.topAnchor, constant: -5)
        ])
    }
    
    open func createSelectedData(row: Int) -> U? {
        return nil
    }
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data.count
    }
    
    public func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return nil
    }
}
