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
    
    private var emailTextField: UITextField!
    private var passwordTextField: UITextField!
    private var loginButton: UIButton!
    private var forgetPassword: UIButton!
    
    private var cancellable: AnyCancellable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        view.backgroundColor = .white
        
        layout()
    }
    
    private func layout() {
        let container = UIView()
        
        emailTextField = customizeTextField(placeHolder: LabelDef.email) {
            let textField = ProjectTextField()
            textField.clearButtonMode = .always
            return textField
        }
        passwordTextField = customizeTextField(placeHolder: LabelDef.password) {
            PasswordTextField()
        }
        loginButton = createLoginButton()
        forgetPassword = createForgetPassword {
            DialogManager.openUrl(string: UrlDef.forgetPassword)
        }
        
        container.addSubviewForAutoLayout(emailTextField)
        container.addSubviewForAutoLayout(passwordTextField)
        container.addSubviewForAutoLayout(loginButton)
        container.addSubviewForAutoLayout(forgetPassword)
        
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
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 30),
            loginButton.widthAnchor.constraint(equalToConstant: 240),
            loginButton.heightAnchor.constraint(equalToConstant: 50),
            loginButton.centerXAnchor.constraint(equalTo: container.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            forgetPassword.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            forgetPassword.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 30),
            forgetPassword.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
        
        view.addSubviewForAutoLayout(container)
        
        NSLayoutConstraint.activate([
            container.leftAnchor.constraint(equalTo: view.leftAnchor),
            container.rightAnchor.constraint(equalTo: view.rightAnchor),
            container.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        // TODO: 削除
        emailTextField.text = "jerold@adams.co"
        passwordTextField.text = "12345"
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    private func customizeTextField(placeHolder: String, creator: () -> UITextField) -> UITextField {
        let textField = creator()
        textField.backgroundColor = .lightGray
        textField.layer.cornerRadius = 20
        textField.placeholder = placeHolder
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
    
    private func createForgetPassword(action: @escaping () -> Void) -> UIButton {
        let button = UIButton()
        let attrinutes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 16),
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        button.setAttributedTitle(
            NSAttributedString(string: LabelDef.forgetPassword, attributes: attrinutes),
            for: .normal
        )
        button.setTitleColor(.blue, for: .normal)
        button.addAction(UIAction { _ in action() }, for: .touchUpInside)
        button.isEnabled = true
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
            
            if let sequeceSupport = self?.resolveSequenceSupport() {
                sequeceSupport.navigateNextSequence(cond: nil)
            } else {
                self?.dismiss(animated: true)
            }
        }
    }
}
