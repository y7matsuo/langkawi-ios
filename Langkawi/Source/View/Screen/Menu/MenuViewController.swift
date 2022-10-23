//
//  MenuViewController.swift
//  Langkawi-iOS
//
//  Created by 松尾 勇気（Yuki Matsuo） on 2022/10/09.
//

import UIKit

class MenuViewController: UIViewController, MenuViewProtocol {
    struct TableCellContent {
        let title: String
        let transitionType: MenuTableCell.TransitionType
        let action: () -> Void
    }
    
    struct TableContent {
        let headerTitle: String
        let cellContents: [TableCellContent]
    }
    
    let presenter: MenuPresentation
    
    private var menuView: UIView!
    private var menuViewConstraintBeforeAnimation: [NSLayoutConstraint]!
    
    private var menuTableView: UITableView!
    private var animated = false
    
    init(presenter: MenuPresentation) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var tableContents: [TableContent] = [
        .init(headerTitle: LabelDef.authorization, cellContents: [
            .init(title: LabelDef.login, transitionType: .navigation, action: { [weak self] in self?.presenter.showLogin() }),
            .init(title: LabelDef.logout, transitionType: .none, action: { [weak self] in self?.presenter.doLogout() })
        ]),
        .init(headerTitle: LabelDef.rules, cellContents: [
            .init(title: LabelDef.serviceRule, transitionType: .web, action: { [weak self] in self?.presenter.showServiceRule() }),
            .init(title: LabelDef.copyright, transitionType: .web, action: { [weak self] in self?.presenter.showCopyright() })
        ])
    ]
    
    private var contentRatio: CGFloat? {
        didSet {
            guard let ratio = contentRatio else {
                return
            }
            menuView.frame.origin.x = view.bounds.width * ratio
        }
    }
    
    private let showedContentRatio: CGFloat = 0.3
    private let reuseIdentifier = "menu"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backButtonTitle = LabelDef.back
        layoutMenuViewBeforeAnimation()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard !animated else { return }
        UIView.animate(withDuration: 0.8, animations: {
            self.contentRatio = self.showedContentRatio
        }) { [weak self] in
            if $0 {
                self?.animated = true
                self?.layoutMenuViewAfterAnimation()
                self?.layoutBackScreen()
                self?.view.setNeedsLayout()
                self?.view.layoutIfNeeded()
            }
        }
    }
    
    private func layoutMenuViewBeforeAnimation() {
        self.menuView = UIView()
        menuView.backgroundColor = ColorDef.surface
        
        view.addSubviewForAutoLayout(menuView)
        self.menuViewConstraintBeforeAnimation = [
            menuView.topAnchor.constraint(equalTo: view.topAnchor),
            menuView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1 - showedContentRatio),
            menuView.leftAnchor.constraint(equalTo: view.rightAnchor),
            menuView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        NSLayoutConstraint.activate(self.menuViewConstraintBeforeAnimation)
        
        setPanGestureRecognizer()
        layoutMenuContent()
    }
    
    private func layoutMenuViewAfterAnimation() {
        NSLayoutConstraint.deactivate(menuViewConstraintBeforeAnimation)
        NSLayoutConstraint.activate([
            menuView.topAnchor.constraint(equalTo: view.topAnchor),
            menuView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1 - showedContentRatio),
            menuView.rightAnchor.constraint(equalTo: view.rightAnchor),
            menuView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func layoutBackScreen() {
        let backScreenView = UIView()
        backScreenView.backgroundColor = ColorDef.blockScreen
        backScreenView.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(backScreenView, belowSubview: menuView)
        view.layoutFit(backScreenView)
        
        let crossButton = UIButton()
        guard let font = UIFont.fontAwesome(type: .solid, size: 32) else {
            return
        }
        crossButton.setAttributedTitle(
            NSAttributedString(string: "xmark", attributes: [.font : font]),
            for: .normal
        )
        crossButton.setTitleColor(.white, for: .normal)
        crossButton.bounds.size = crossButton.intrinsicContentSize
        crossButton.addAction(UIAction { [weak self] _ in self?.resign() }, for: .touchUpInside)
        backScreenView.addSubviewForAutoLayout(crossButton)
        NSLayoutConstraint.activate([
            crossButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            crossButton.centerXAnchor.constraint(equalTo: view.leftAnchor, constant: (UIScreen.main.bounds.width * showedContentRatio) / 2)
        ])
    }
    
    private func layoutMenuContent() {
        menuTableView = UITableView()
        menuTableView.dataSource = self
        menuTableView.delegate = self
        menuTableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        menuTableView.register(MenuTableCell.self, forCellReuseIdentifier: reuseIdentifier)
        menuTableView.register(MenuTableHeader.self, forHeaderFooterViewReuseIdentifier: reuseIdentifier)
        
        menuView.addSubviewForAutoLayout(menuTableView)
        menuView.layoutFit(menuTableView)
    }
      
    func resign() {
        UIView.animate(
            withDuration: 0.8,
            delay: 0,
            animations: { self.contentRatio = 1 }
        ) { [weak self] in
            if $0 {
                self?.navigationController?.view.removeFromSuperview()
                self?.navigationController?.removeFromParent()
            }
        }
    }
    
    private func setPanGestureRecognizer() {
        let recognizer = UIPanGestureRecognizer(target: self, action: #selector(self.onPanGesture(_:)))
        menuView.addGestureRecognizer(recognizer)
    }
    
    @objc private func onPanGesture(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: self.view)
        
        if sender.state == .began && translation.x > 0 {
            resign()
        }
    }
}

extension MenuViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableContents[section].cellContents.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.tableContents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: self.reuseIdentifier, for: indexPath) as? MenuTableCell else {
            return UITableViewCell()
        }
        cell.configure(content: self.tableContents.getCellContentAt(section: indexPath.section, row: indexPath.row))
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: reuseIdentifier) as? MenuTableHeader else {
            return UIView()
        }
        header.configure(title: self.tableContents[section].headerTitle)
        return header
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let content = self.tableContents.getCellContentAt(section: indexPath.section, row: indexPath.row)
        content.action()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
}

class MenuTableCell: UITableViewCell {
    enum TransitionType {
        case navigation
        case web
        case none
    }
    
    private var titleLabel: UILabel!
    private var iconLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        titleLabel = UILabel()
        titleLabel.font = .systemFont(ofSize: 16)
        contentView.addSubviewForAutoLayout(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        iconLabel = UILabel()
        iconLabel.font = .fontAwesome(type: .solid, size: 16)
        contentView.addSubviewForAutoLayout(iconLabel)
        NSLayoutConstraint.activate([
            iconLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
            iconLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    func configure(content: MenuViewController.TableCellContent) {
        titleLabel.text = content.title
        titleLabel.bounds.size = titleLabel.intrinsicContentSize
        
        let icon: String
        switch content.transitionType {
        case .navigation:
            icon = "arrow-right"
        case .web:
            icon = "right-to-bracket"
        case .none:
            icon = ""
        }
        iconLabel.text = icon
        iconLabel.bounds.size = iconLabel.intrinsicContentSize
    }
}

class MenuTableHeader: UITableViewHeaderFooterView {
    
    private var titleLabel: UILabel!
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        contentView.backgroundColor = ColorDef.surface
        
        titleLabel = UILabel()
        titleLabel.font = .systemFont(ofSize: 18)
        contentView.addSubviewForAutoLayout(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    func configure(title: String) {
        titleLabel.text = title
        titleLabel.bounds.size = titleLabel.intrinsicContentSize
    }
}

extension Array where Element == MenuViewController.TableContent {
    
    func getCellContentAt(section: Int, row: Int) -> MenuViewController.TableCellContent {
        self[section].cellContents[row]
    }
}
