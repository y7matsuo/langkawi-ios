//
//  RelationStatus.swift
//  Langkawi-iOS
//
//  Created by Yuki Matsuo on 2022/09/18.
//

import Foundation

enum RelationStatus: String, Codable, CaseIterable {
    case pending
    case withdraw
    case accepted
    case declined
    case disconnected
    case refused
    
    func toButtonTitle() -> String {
        switch self {
        case .pending:
            return LabelDef.pending
        case .withdraw:
            return LabelDef.withdraw
        case .accepted:
            return LabelDef.accepted
        case .declined:
            return LabelDef.declined
        case .disconnected:
            return LabelDef.disconnected
        case .refused:
            return LabelDef.refused
        }
    }
    
    func toConfirmMessage() -> String {
        switch self {
        case .pending:
            return MessageDef.confirmPending
        case .withdraw:
            return MessageDef.confirmWithdraw
        case .accepted:
            return MessageDef.confirmAccepted
        case .declined:
            return MessageDef.confirmDeclined
        case .disconnected:
            return MessageDef.confirmDisconnected
        case .refused:
            return MessageDef.confirmRefused
        }
    }
}
