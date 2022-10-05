//
//  User.swift
//  Langkawi-iOS
//
//  Created by Yuki Matsuo on 2022/09/14.
//

import Foundation

struct UsersResponse: Codable {
    let list: [User]
    let pageSize: Int
    let count: Int
    let total: Int
}
