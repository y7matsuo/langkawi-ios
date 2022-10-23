//
//  DialogEventSupport.swift
//  Langkawi-iOS
//
//  Created by Yuki Matsuo on 2022/09/15.
//

import UIKit
import Combine

enum DialogEvent {
    case ok
    case cancel
    case userDefined(content: Any)
}

class DialogPresenterSupportInjector: LifecycleInjector {
    private let handler: (DialogEvent) -> Void
    private weak var eventSubject: PassthroughSubject<DialogEvent, Never>?
    private var cancellable: AnyCancellable?
    
    init(handler: @escaping (DialogEvent) -> Void, eventSubject: PassthroughSubject<DialogEvent, Never>) {
        self.handler = handler
        self.eventSubject = eventSubject
    }
    
    func onViewDidLoad() {
        cancellable = self.eventSubject?.sink { [weak self] in
            self?.handler($0)
        }
    }
}

protocol DialogPresenterSupport: LifecycleInjectableViewController {
    var eventSubject: PassthroughSubject<DialogEvent, Never> { get }
}
    
extension DialogPresenterSupport {
    func useDialogPresenterSupport(handler: @escaping (DialogEvent) -> Void) {
        let injector = DialogPresenterSupportInjector(handler: handler, eventSubject: eventSubject)
        registerLifecycleInjector(injector: injector)
    }
    
    func presentDialog(vc: UIViewController, animated: Bool) {
        self.present(vc, animated: animated) {
            guard let vc = vc as? DialogPresentedSupport else {
                return
            }
            vc.parentVC = self
        }
    }
}

protocol DialogPresentedSupport: UIViewController {
    var parentVC: DialogPresenterSupport? { get set }
}

extension DialogPresentedSupport {
    
    func sendDialogEventAndDismiss(event: DialogEvent) {
        self.parentVC?.eventSubject.send(event)
        self.dismiss(animated: true)
    }
}
