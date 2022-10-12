//
//  BaseWebView.swift
//  Langkawi-iOS
//
//  Created by 松尾 勇気（Yuki Matsuo） on 2022/10/12.
//

import UIKit
import WebKit

class BaseWebViewController: UIViewController {
    let urlString: String
    
    var webView: WKWebView!
    var backButton: UIButton!
    var forwardButton: UIButton!
    
    init(title: String, urlString: String) {
        self.urlString = urlString
        super.init(nibName: nil, bundle: nil)
        navigationItem.title = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        layout()
        
        guard let url = URL(string: urlString) else {
            return
        }
        let requesrt = URLRequest(url: url)
        webView.load(requesrt)
    }
    
    private func layout() {
        let configuration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: configuration)
        webView.navigationDelegate = self
        
        layoutBackForwardButtons()
        
        view.addSubviewForAutoLayout(webView)
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 10),
            webView.leftAnchor.constraint(equalTo: view.leftAnchor),
            webView.rightAnchor.constraint(equalTo: view.rightAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func layoutBackForwardButtons() {
        backButton = createButton(title: "chevron-left", action: { [weak self] in self?.webView.goBack() })
        forwardButton = createButton(title: "chevron-right", action: { [weak self] in self?.webView.goForward() })
        
        view.addSubviewForAutoLayout(backButton)
        view.addSubviewForAutoLayout(forwardButton)
        
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            backButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30),
            forwardButton.topAnchor.constraint(equalTo: backButton.topAnchor),
            forwardButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30)
        ])
    }
    
    private func createButton(title: String, action: @escaping () -> Void) -> UIButton {
        let button = UIButton()
        guard let font = UIFont.fontAwesome(type: .solid, size: 28) else {
            return button
        }
        button.setAttributedTitle(
            NSAttributedString(string: title, attributes: [.font : font]),
            for: .normal
        )
        button.addAction(UIAction { _ in action() }, for: .touchUpInside)
        button.bounds.size = button.intrinsicContentSize
        button.isHidden = true
        return button
    }
}

extension BaseWebViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        self.backButton.isHidden = !webView.canGoBack
        self.forwardButton.isHidden = !webView.canGoForward
    }
}
