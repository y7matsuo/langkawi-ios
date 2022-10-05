//
//  DBKeyValue.swift
//  Langkawi-iOS
//
//  Created by Yuki Matsuo on 2022/09/10.
//

import RealmSwift

class DBKeys {
    static let apiToken = "apiToken"
    static let loginUserId = "loginUserId"
}

class DBKeyValue: Object {
    @Persisted var key: String = ""
    @Persisted var value: String = ""
    
    convenience init(key: String, value: String) {
        self.init()
        self.key = key
        self.value = value
    }
}
