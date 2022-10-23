//
//  TalkRoomsResponse.swift
//  Langkawi-iOS
//
//  Created by Yuki Matsuo on 2022/09/30.
//

import Foundation

struct TalkRoomsResponse: Codable {
    let list: [TalkRoom]
    let pageSize: Int
    let count: Int
    let total: Int
}
