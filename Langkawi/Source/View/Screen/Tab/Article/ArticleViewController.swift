//
//  ArticleViewController.swift
//  Langkawi-iOS
//
//  Created by 松尾 勇気（Yuki Matsuo） on 2022/10/11.
//

import UIKit

class ArticleViewController: UIViewController {
    
    override func viewDidLoad() {
        layoutNavigationBar()
        layout()
    }
    
    private func layoutNavigationBar() {
        navigationItem.title = LabelDef.article
        addMenuButton()
        layoutNavigationBarBorder()
    }
    
    private func layout() {
        let label = UILabel()
        label.text = LabelDef.article
        label.bounds.size = label.intrinsicContentSize
        view.addSubviewForAutoLayout(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
