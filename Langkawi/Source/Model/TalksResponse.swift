//
//  TalksResponse.swift
//  Langkawi-iOS
//
//  Created by Yuki Matsuo on 2022/09/30.
//

import Foundation

struct TalksResponse: Codable {
    let list: [TalkResponse]
    let pageSize: Int
    let count: Int
    let total: Int
}
