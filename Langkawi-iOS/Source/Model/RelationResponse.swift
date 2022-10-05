//
//  RelationResponse.swift
//  Langkawi-iOS
//
//  Created by Yuki Matsuo on 2022/09/18.
//

import Foundation

struct RelationResponse: Codable {
    let user: User
    let positionStatus: RelationPositionStatus
    let nextStatuses: [RelationStatus]
    let actionADate: Date?
    let actionBDate: Date?
    let actionCDate: Date?
}
