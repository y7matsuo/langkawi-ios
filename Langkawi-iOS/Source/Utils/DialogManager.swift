//
//  DialogManager.swift
//  Langkawi-iOS
//
//  Created by Yuki Matsuo on 2022/09/03.
//

import Foundation
import UIKit

class DialogManager {
    
    static func showAlert(
        vc: UIViewController?,
        title: String?,
        message: String?,
        ok: UIAlertAction = UIAlertAction(title: "OK", style: .default),
        cancel: UIAlertAction? = nil
    ) {
        let dialog = UIAlertController(title: title, message: message, preferredStyle: .alert)
        dialog.addAction(ok)
        if let cancel = cancel {
            dialog.addAction(cancel)
        }
        vc?.present(dialog, animated: false, completion: nil)
    }
    
    static func showDialog(presenter: UIViewController?, vc: UIViewController, style: UIModalPresentationStyle = .fullScreen) {
        vc.modalPresentationStyle = style
        if let presenter = presenter as? DialogPresenterSupport {
            presenter.presentDialog(vc: vc, animated: true)
        } else {
            presenter?.present(vc, animated: true)
        }
    }
}
