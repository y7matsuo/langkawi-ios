//
//  SequenceViewController.swift
//  Langkawi-iOS
//
//  Created by 松尾 勇気（Yuki Matsuo） on 2022/10/13.
//

import UIKit

struct SequenceResolver {
    let resolveVC: () -> UIViewController?
    let next: (Any?) -> SequenceResolver?
}

class SequenceViewController: UINavigationController, SequenceSupport {
    
    private var currentResolver: SequenceResolver
    private let completion: (UIViewController) -> Void
    
    init(rootResolver: SequenceResolver, completion: @escaping (UIViewController) -> Void) {
        self.currentResolver = rootResolver
        self.completion = completion
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigateNextSequence()
    }
    
    func navigateNextSequence(cond: Any? = nil) {
        guard let nextResolver = currentResolver.next(cond),
              let nextVC = nextResolver.resolveVC() else {
            completion(self)
            return
        }
        self.currentResolver = nextResolver
        self.pushViewController(nextVC, animated: true)
    }
}
