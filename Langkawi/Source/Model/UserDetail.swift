//
//  UserDetail.swift
//  Langkawi-iOS
//
//  Created by Yuki Matsuo on 2022/09/14.
//

import Foundation

struct UserDetail: Codable {
    let id: Int
    let userId: Int
    let descriptionA: String?
    let pictureA: ImageUrl?
    let createdAt: Date
    let updatedAt: Date
}
