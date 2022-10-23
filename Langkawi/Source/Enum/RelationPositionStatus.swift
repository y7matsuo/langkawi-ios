//
//  RelationPositionStatus.swift
//  Langkawi-iOS
//
//  Created by Yuki Matsuo on 2022/09/18.
//

import Foundation

enum RelationPositionStatus: String, Codable, CaseIterable {
    case pendingMe = "pending_me"
    case pendingYou = "pending_you"
    case withdrawMe = "withdraw_me"
    case withdrawYou = "withdraw_you"
    case acceptedMe = "accepted_me"
    case acceptedYou = "accepted_you"
    case declinedMe = "declined_me"
    case declinedYou = "declined_you"
    case disconnectedMe = "disconnected_me"
    case disconnectedYou = "disconnected_you"
    case refusedMe = "refused_me"
    case refusedYou = "refused_you"
    
    func string() -> String {
        switch self {
        case .pendingMe:
            return LabelDef.pending.me()
        case .pendingYou:
            return LabelDef.pending.you()
        case .withdrawMe:
            return LabelDef.withdraw.me()
        case .withdrawYou:
            return LabelDef.withdraw.you()
        case .acceptedMe:
            return LabelDef.accepted.me()
        case .acceptedYou:
            return LabelDef.accepted.you()
        case .declinedMe:
            return LabelDef.declined.me()
        case .declinedYou:
            return LabelDef.declined.you()
        case .disconnectedMe:
            return LabelDef.disconnected.me()
        case .disconnectedYou:
            return LabelDef.disconnected.you()
        case .refusedMe:
            return LabelDef.refused.me()
        case .refusedYou:
            return LabelDef.refused.you()
        }
    }
}

fileprivate extension String {
    func me() -> String {
        return "\(LabelDef.fromMe)\(self)"
    }
    
    func you() -> String {
        return "\(LabelDef.fromYou)\(self)"
    }
}
