//
//  TutorialViewController.swift
//  Langkawi-iOS
//
//  Created by 松尾 勇気（Yuki Matsuo） on 2022/10/13.
//

import UIKit

enum TutorialType {
    case A
    case B
}

enum TutorialAction {
    case next
    case skip
}

class TutorialViewController: UIViewController {
    private let tutorialType: TutorialType
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    
    init(tutorialType: TutorialType) {
        self.tutorialType = tutorialType
        super.init(nibName: "TutorialViewController", bundle: nil)
    }
    
    override func loadView() {
        super.loadView()
        
        image.image = resolveImage()
        
        submitButton.configurePrimary(title: LabelDef.next) { [weak self] in
            self?.onClickButton(action: .next)
        }
        skipButton.configureSecondary(title: LabelDef.skip) { [weak self] in
            self?.onClickButton(action: .skip)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func resolveImage() -> UIImage? {
        switch tutorialType {
        case .A:
            return UIImage(named: "TutorialA")
        case .B:
            return UIImage(named: "TutorialB")
        }
    }
    
    private func onClickButton(action: TutorialAction) {
        resolveSequenceSupport()?.navigateNextSequence(cond: action)
    }
}
