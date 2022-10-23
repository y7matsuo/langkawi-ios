//
//  DescriptionEditViewController.swift
//  Langkawi-iOS
//
//  Created by Yuki Matsuo on 2022/09/27.
//

import UIKit
import Combine

class DescriptionEditViewController: BaseViewController {
    lazy var vm = DescriptionEditViewModel(owner: self)
    
    private var textView: UITextView?
    
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        vm.setup()
        sink()
        layout()
        registerTapGestureRecognizer()
        super.viewDidLoad()
    }
    
    private func layout() {
        let titleLabel = UILabel()
        titleLabel.text = LabelDef.selfDescriotion
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        
        view.addSubviewForAutoLayout(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10)
        ])
        
        let textView = UITextView()
        textView.backgroundColor = .lightGray
        textView.keyboardType = .default
        textView.textAlignment = .left
        textView.layer.cornerRadius = 10
        self.textView = textView
        
        view.addSubviewForAutoLayout(textView)
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            textView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
            textView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            textView.heightAnchor.constraint(equalToConstant: 180)
        ])
        
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
    
    private func sink() {
        vm.$description.sink { [weak self] in
            self?.textView?.text = $0
        }.store(in: &cancellables)
    }
    
    private func registerTapGestureRecognizer() {
        let recognizer = UITapGestureRecognizer()
        recognizer.addTarget(self, action: #selector(self.tapped(_:)))
        view.addGestureRecognizer(recognizer)
    }
    
    @objc func tapped(_ sender: UITapGestureRecognizer) {
        if textView?.isFirstResponder == true {
            vm.description = textView?.text
            textView?.resignFirstResponder()
        }
    }
}

extension DescriptionEditViewController: UITextViewDelegate {

    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        self.vm.description = textView.text
        return textView.resignFirstResponder()
    }
}
