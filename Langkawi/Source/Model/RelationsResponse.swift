//
//  RelationsResponse.swift
//  Langkawi-iOS
//
//  Created by Yuki Matsuo on 2022/09/18.
//

import Foundation

struct RelationsResponse: Codable {
    let list: [RelationResponse]
    let pageSize: Int
    let count: Int
    let total: Int
}
