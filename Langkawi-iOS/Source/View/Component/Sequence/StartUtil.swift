//
//  StartUtil.swift
//  Langkawi-iOS
//
//  Created by 松尾 勇気（Yuki Matsuo） on 2022/10/13.
//

import UIKit

class StartUitl {
    
    static var sequenceResolvers: [SequenceResolver] {
        let login = SequenceResolver(resolveVC: {
            if LoginSessionManager.getLoginUserId() == nil {
                return LoginViewController()
            } else {
                return nil
            }            
        }) { _ in nil }
        
        let tutorialB = SequenceResolver(resolveVC: { TutorialViewController(tutorialType: .B) }) {
            guard let action = $0 as? TutorialAction else { return nil }
            switch action {
            case .next:
                return login
            case .skip:
                return login
            }
        }
        
        let tutorialA = SequenceResolver(resolveVC: { TutorialViewController(tutorialType: .A) }) {
            guard let action = $0 as? TutorialAction else { return nil }
            switch action {
            case .next:
                return tutorialB
            case .skip:
                return login
            }
        }
        
        let root = SequenceResolver(resolveVC: { UIViewController() }) { _ in tutorialA }
        return [root, tutorialA, tutorialB, login]
    }
}
