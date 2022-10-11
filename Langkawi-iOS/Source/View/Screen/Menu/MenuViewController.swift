//
//  MenuViewController.swift
//  Langkawi-iOS
//
//  Created by 松尾 勇気（Yuki Matsuo） on 2022/10/09.
//

import UIKit

class MenuViewController: UIViewController, MenuViewProtocol {
    var beforeShow: (() -> Void)?
    var afterResign: (() -> Void)?
    var presenter: MenuPresentation?
    
    private var contentRatio: CGFloat? {
        didSet {
            guard let ratio = contentRatio else {
                return
            }
            view.frame.origin.x = -view.bounds.width * ratio
        }
    }
    
    private let showedContentRatio: CGFloat = 0.3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ColorDef.surface
        contentRatio = 1
        
        setPanGestureRecognizer()
        
        let window = UIApplication.shared.connectedScenes.map { $0 as? UIWindowScene }.compactMap { $0 }.first?.windows.first
        layout(window: window)
    }
    
    private func layout(window: UIWindow?) {
        guard let window = window else {
            return
        }
        let sub = UIView()
        sub.backgroundColor = ColorDef.surface
        
        view.addSubviewForAutoLayout(sub)
        NSLayoutConstraint.activate([
            sub.topAnchor.constraint(equalTo: view.topAnchor, constant: window.safeAreaInsets.top),
            sub.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1 - showedContentRatio),
            sub.rightAnchor.constraint(equalTo: view.rightAnchor),
            sub.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -window.safeAreaInsets.bottom)
        ])
        
        layoutContent(parent: sub)
    }
    
    private func layoutContent(parent: UIView) {
        guard let presenter = presenter else {
            return
        }
    
        presenter.showLoginRow() ? layoutLoginRow(parent: parent) : layoutLogoutRow(parent: parent)
    }
    
    private func layoutLoginRow(parent: UIView) {
        layoutRow(view: parent, topAnchor: parent.topAnchor, title: LabelDef.login, showBottomBorder: true) { [weak self] in
            self?.presenter?.showLogin()
        }
    }
    
    private func layoutLogoutRow(parent: UIView) {
        layoutRow(view: parent, topAnchor: parent.topAnchor, title: LabelDef.logout, showBottomBorder: true) { [weak self] in
            self?.presenter?.doLogout()
        }
    }
    
    @discardableResult
    private func layoutRow(
        view: UIView,
        topAnchor: NSLayoutYAxisAnchor,
        title: String,
        showBottomBorder: Bool,
        action: @escaping () -> Void
    ) -> UIView {
        let row = MenuRowView(title: title, showBottomBorder: showBottomBorder, action: action)
        
        view.addSubviewForAutoLayout(row)
        NSLayoutConstraint.activate([
            row.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            row.leftAnchor.constraint(equalTo: view.leftAnchor),
            row.rightAnchor.constraint(equalTo: view.rightAnchor),
            row.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        return row
    }
    
    func show(parent: UIViewController) {
        self.beforeShow?()
        
        parent.addChild(self)
        parent.view.addSubview(view)
        self.didMove(toParent: parent)
        
        UIView.animate(withDuration: 0.8) { [weak self] in
            self?.contentRatio = self?.showedContentRatio
        }
    }
    
    func resign() {
        UIView.animate(
            withDuration: 0.8,
            delay: 0,
            animations: { self.view.frame.origin.x = -self.view.bounds.width }
        ) { [weak self] in
            if $0 {
                self?.afterResign?()
                self?.view.removeFromSuperview()
                self?.removeFromParent()
            }
        }
    }
    
    private func setPanGestureRecognizer() {
        let recognizer = UIPanGestureRecognizer(target: self, action: #selector(self.onPanGesture(_:)))
        view.addGestureRecognizer(recognizer)
    }
    
    @objc private func onPanGesture(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: self.view)
        
        if sender.state == .began && translation.x < 0 {
            resign()
        }
    }
}

class MenuRowView: UIView {
    
    private let action: () -> Void
    
    init(title: String, showBottomBorder: Bool, action: @escaping () -> Void) {
        self.action = action
        super.init(frame: .zero)
        layout(title: title, showBottomBorder: showBottomBorder)
        setTapRecognizer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout(title: String, showBottomBorder: Bool) {
        let label = UILabel()
        label.text = title
        label.font = UIFont.systemFont(ofSize: 18)
        label.bounds.size = label.intrinsicContentSize
        
        self.addSubviewForAutoLayout(label)
        NSLayoutConstraint.activate([
            label.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10),
            label.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        
        let arrow = UILabel.fontAwesome(type: .solid, name: "right-to-bracket", color: .black, size: 18)
        self.addSubviewForAutoLayout(arrow)
        NSLayoutConstraint.activate([
            arrow.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10),
            arrow.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        
        layoutBorder(isTop: true)
        if showBottomBorder {
            layoutBorder(isTop: false)
        }
    }
    
    private func layoutBorder(isTop: Bool) {
        let border = UIView()
        border.backgroundColor = .black
        self.addSubviewForAutoLayout(border)
        NSLayoutConstraint.activate([
            border.leftAnchor.constraint(equalTo: self.leftAnchor),
            border.rightAnchor.constraint(equalTo: self.rightAnchor),
            border.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        if isTop {
            border.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        } else {
            border.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        }
    }
    
    private func setTapRecognizer() {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(self.onTap(_:)))
        self.addGestureRecognizer(recognizer)
    }
    
    @objc private func onTap(_ sender: UITapGestureRecognizer) {
        UIView.animate(
            withDuration: 0.1,
            animations: { self.backgroundColor = .yellow }
        ) { [weak self] in
            if $0 {
                UIView.animate(
                    withDuration: 0.1,
                    animations: { self?.backgroundColor = ColorDef.surface }
                ) { [weak self] in
                    if $0 {
                        self?.action()
                    }
                }
            }
        }
    }
}
