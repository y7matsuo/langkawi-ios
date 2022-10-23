//
//  TalkResponse.swift
//  Langkawi-iOS
//
//  Created by Yuki Matsuo on 2022/09/30.
//

import Foundation

struct TalkResponse: Codable {
    let id: Int
    let relationId: Int
    let message: String
    let submitter: SubmitterType
    let status: TalkStatus
    let createdAt: Date
    let updatedAt: Date
}
