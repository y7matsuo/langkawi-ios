//
//  PreviewRouter.swift
//  Langkawi-iOS
//
//  Created by 松尾 勇気（Yuki Matsuo） on 2022/10/11.
//

import SwiftUI

protocol PreviewRouter: AnyObject {
    func assemble() -> UIViewController
}

struct PreviewViewControllerRepresentable: UIViewControllerRepresentable {
    let router: PreviewRouter
    
    func makeUIViewController(context: Context) -> some UIViewController {
        self.router.assemble()
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
}
