//
//  Errors.swift
//  Langkawi-iOS
//
//  Created by Yuki Matsuo on 2022/09/04.
//

import Foundation

struct APIStatusError: Error {
    let status: Int
    let response: ErrorResponse
}
