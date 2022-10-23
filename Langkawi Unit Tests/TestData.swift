//
//  TestData.swift
//  Langkawi-iOSTests
//
//  Created by 松尾 勇気（Yuki Matsuo） on 2022/10/14.
//

import Foundation
@testable import Langkawi

class TestData {
    
    class ErrorForTest: Error {}
    
    static var userDetail: UserDetail {
        return UserDetail(
            id: 1,
            userId: 100,
            descriptionA: "巡回かおつきこくふくする。かいころく川底そんけい。せいぞう盛り上がるやすい。いっかいずいぶんばい。せっとく野獣あい。冬休みしょうじょういち。碁じどうし靖国神社。",
            pictureA: nil,
            createdAt: Date(),
            updatedAt: Date()
        )
    }
    
    static var user: User {
        return User(
            id: 100,
            userType: .general,
            firstName: "勇気",
            lastName: "松尾",
            gender: .male,
            age: 39,
            accountId: 2,
            detail: userDetail,
            createdAt: Date(),
            updatedAt: Date()
        )
    }
}
