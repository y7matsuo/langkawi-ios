//
//  NameEditViewController.swift
//  Langkawi-iOS
//
//  Created by Yuki Matsuo on 2022/09/27.
//

import UIKit
import Combine

class NameEditViewController: BaseViewController, DialogPresenterSupport {
    var eventSubject: PassthroughSubject<DialogEvent, Never> = PassthroughSubject()
    
    private lazy var vm = NameEditViewModel(owner: self)
    private var cancellables = Set<AnyCancellable>()
    
    var firstNameTextField: ProjectTextField?
    var lastNameTextField: ProjectTextField?
    var ageButton: UIButton?
    var genderButton: UIButton?
    
    override func viewDidLoad() {
        vm.setup()
        sink()
        layout()
        super.viewDidLoad()
    }
    
    private func layout() {
        let lastNameTextField = textField()
        self.lastNameTextField = lastNameTextField
        
        layoutRow(
            title: LabelDef.lastName,
            content: lastNameTextField,
            contentHeight: 40,
            contentWidth: 120,
            topAnchor: view.safeAreaLayoutGuide.topAnchor,
            margin: 20
        )
        
        let firstNameTextField = textField()
        self.firstNameTextField = firstNameTextField
        
        layoutRow(
            title: LabelDef.firstName,
            content: firstNameTextField,
            contentHeight: 40,
            contentWidth: 120,
            topAnchor: lastNameTextField.bottomAnchor,
            margin: 20
        )
        
        let ageButton = button { [weak self] in
            let vc = AgePickerViewDialog()
            vc.initialSelected = self?.vm.age
            return vc
        }
        self.ageButton = ageButton
        
        layoutRow(
            title: LabelDef.age,
            content: ageButton,
            contentHeight: 30,
            contentWidth: 60,
            topAnchor: firstNameTextField.bottomAnchor,
            margin: 20
        )
        
        let genderButton = button { [weak self] in
            let vc = GenederPickerViewDialog()
            vc.initialSelected = self?.vm.gender
            return vc
        }
        self.genderButton = genderButton
        
        layoutRow(
            title: LabelDef.gender,
            content: genderButton,
            contentHeight: 30,
            contentWidth: 60,
            topAnchor: ageButton.bottomAnchor,
            margin: 20
        )
        
        let submitButton = ProjectStyles.primaryButton(title: LabelDef.submit, action: UIAction { [weak self] _ in
            self?.vm.submit {
                self?.navigationController?.popViewController(animated: true)
            }
        })
        
        view.addSubviewForAutoLayout(submitButton)
        NSLayoutConstraint.activate([
            submitButton.widthAnchor.constraint(equalToConstant: 240),
            submitButton.heightAnchor.constraint(equalToConstant: 40),
            submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            submitButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24)
        ])
    }
    
    private func textField() -> ProjectTextField {
        let textField = ProjectTextField()
        textField.delegate = self
        textField.keyboardType = .default
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .lightGray
        return textField
    }
    
    private func button(vcFactory: @escaping () -> UIViewController) -> UIButton {
        let button = UIButton()
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.addAction(UIAction { [weak self] _ in
            DialogManager.showDialog(presenter: self, vc: vcFactory(), style: .overFullScreen)
        }, for: .touchUpInside)
        return button
    }
    
    private func layoutRow(
        title: String,
        content: UIView,
        contentHeight: CGFloat,
        contentWidth: CGFloat,
        topAnchor: NSLayoutYAxisAnchor,
        margin: CGFloat
    ) {
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        view.addSubviewForAutoLayout(titleLabel)
        view.addSubviewForAutoLayout(content)
        
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: content.centerYAnchor),
            titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10)
        ])
        
        NSLayoutConstraint.activate([
            content.leftAnchor.constraint(equalTo: titleLabel.rightAnchor, constant: 10),
            content.topAnchor.constraint(equalTo: topAnchor, constant: margin),
            content.heightAnchor.constraint(equalToConstant: contentHeight),
            content.widthAnchor.constraint(equalToConstant: contentWidth)
        ])
    }
    
    private func sink() {
        eventSubject.sink { [weak self] in
            if case .userDefined(content: let selected) = $0 {
                switch selected {
                case let selected as AgePickerViewDialogSelectedData:
                    self?.vm.age = selected.data
                case let selected as GenderPickerViewDialogSelectedData:
                    self?.vm.gender = selected.data
                default:
                    return
                }
            }
        }.store(in: &cancellables)
        
        vm.$firstName.sink { [weak self] in
            self?.firstNameTextField?.text = $0
        }.store(in: &cancellables)
        
        vm.$lastName.sink { [weak self] in
            self?.lastNameTextField?.text = $0
        }.store(in: &cancellables)
        
        vm.$age.sink { [weak self] in
            guard let age = $0 else {
                return
            }
            self?.ageButton?.setAttributedTitle(self?.buttonAttributedString(string: String(age)), for: .normal)
        }.store(in: &cancellables)
        
        vm.$gender.sink { [weak self] in
            guard let gender = $0 else {
                return
            }
            self?.genderButton?.setAttributedTitle(self?.buttonAttributedString(string: gender.toLabel()), for: .normal)
            self?.genderButton?.setTitleColor(gender.toColor(), for: .normal)
        }.store(in: &cancellables)
    }
    
    private func buttonAttributedString(string: String) -> NSAttributedString {
        return NSAttributedString(string: string, attributes: [.font: UIFont.systemFont(ofSize: 20)])
    }
}

extension NameEditViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        vm.firstName = firstNameTextField?.text
        vm.lastName = lastNameTextField?.text
        return textField.resignFirstResponder()
    }
}
