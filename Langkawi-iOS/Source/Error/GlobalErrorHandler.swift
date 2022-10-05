//
//  GlobalErrorHandler.swift
//  Langkawi-iOS
//
//  Created by Yuki Matsuo on 2022/09/03.
//

import Alamofire

class GlobalErrorHandler {
    
    static func handle(error: Error, vc: UIViewController?) {
        var title: String?
        let message: String?
        switch error {
        case let err as APIStatusError:
            switch err.status {
            case 401:
                DialogManager.showDialog(presenter: vc, vc: LoginViewController())
                return
            default:
                break
            }
            title = err.response.error
            message = err.response.exception
        case let err as AFError:
            message = err.localizedDescription
        default:
            message = error.localizedDescription
        }
        
        DialogManager.showAlert(vc: vc, title: title, message: message)
    }
}
