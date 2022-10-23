//
//  ErrorResponse.swift
//  Langkawi-iOS
//
//  Created by Yuki Matsuo on 2022/09/01.
//

import Foundation

struct ErrorResponse: Codable {
    let error: String
    let exception: String
}
