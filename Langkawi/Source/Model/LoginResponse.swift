//
//  LoginResponse.swift
//  Langkawi-iOS
//
//  Created by Yuki Matsuo on 2022/09/11.
//

import Foundation

struct LoginResponse: Codable {
    let token: String
    let userId: Int
}
