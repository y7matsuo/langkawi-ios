//
//  LoginViewController.swift
//  Langkawi-iOS
//
//  Created by Yuki Matsuo on 2022/09/04.
//

import Foundation
import UIKit
import Combine

class LoginViewController: BaseViewController, UITextFieldDelegate {
    private lazy var vm = LoginViewModel()
    
    private var emailTextField: UITextField?
    private var passwordTextField: UITextField?
    
    private var cancellable: AnyCancellable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        layout()
    }
    
    private func layout() {
        let container = UIView()
        
        let emailTextField = createTextField(placeHolder: LabelDef.email, isSecureText: false)
        let passwordTextField = createTextField(placeHolder: LabelDef.password, isSecureText: true)
        let button = createLoginButton()
        
        container.addSubviewForAutoLayout(emailTextField)
        container.addSubviewForAutoLayout(passwordTextField)
        container.addSubviewForAutoLayout(button)
        
        NSLayoutConstraint.activate([
            emailTextField.topAnchor.constraint(equalTo: container.topAnchor),
            emailTextField.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 20),
            emailTextField.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -20),
            emailTextField.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        NSLayoutConstraint.activate([
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 30),
            passwordTextField.leftAnchor.constraint(equalTo: emailTextField.leftAnchor),
            passwordTextField.rightAnchor.constraint(equalTo: emailTextField.rightAnchor),
            passwordTextField.heightAnchor.constraint(equalTo: emailTextField.heightAnchor),
        ])
        
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 30),
            button.widthAnchor.constraint(equalToConstant: 240),
            button.heightAnchor.constraint(equalToConstant: 50),
            button.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            button.centerXAnchor.constraint(equalTo: container.centerXAnchor)
        ])
        
        view.addSubviewForAutoLayout(container)
        
        NSLayoutConstraint.activate([
            container.leftAnchor.constraint(equalTo: view.leftAnchor),
            container.rightAnchor.constraint(equalTo: view.rightAnchor),
            container.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        self.emailTextField = emailTextField
        self.passwordTextField = passwordTextField
        
        // TODO: 削除
        emailTextField.text = "jerold@adams.co"
        passwordTextField.text = "12345"
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    private func createTextField(placeHolder: String, isSecureText: Bool) -> UITextField {
        let textField = ProjectTextField()
        textField.backgroundColor = .lightGray
        textField.borderStyle = .roundedRect
        textField.placeholder = placeHolder
        textField.isSecureTextEntry = isSecureText
        textField.clearButtonMode = .always
        textField.keyboardType = .default
        textField.delegate = self
        return textField
    }
    
    private func createLoginButton() -> UIButton {
        let button = UIButton()
        let titleAttr: [NSAttributedString.Key : Any] = [
            .font : UIFont.systemFont(ofSize: 20, weight: .bold)
        ]
        let title = NSAttributedString(string: LabelDef.login, attributes: titleAttr)
        button.setAttributedTitle(title, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .green
        button.layer.cornerRadius = 25
        button.addTarget(self, action: #selector(self.onClickButton(_:)), for: .touchUpInside)
        return button
    }
    
    @objc func onClickButton(_ sender: UIButton) {
        cancellable = self.request(requester: { [weak self] in
            guard let email = self?.emailTextField?.text,
                  let password = self?.passwordTextField?.text else {
                return nil
            }
            return vm.loginAPI.login(email: email, password: password)
        }) { [weak self] (response: LoginResponse) in
            self?.vm.loginCompletion(response: response)
            self?.dismiss(animated: true)
        }
    }
}
