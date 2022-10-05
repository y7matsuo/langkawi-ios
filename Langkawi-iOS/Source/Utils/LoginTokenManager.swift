//
//  LoginTokenManager.swift
//  Langkawi-iOS
//
//  Created by Yuki Matsuo on 2022/09/20.
//

import Combine
import RealmSwift

class LoginTokenManager {
    
    static var loginTokenStored: PassthroughSubject<Bool, Never> = PassthroughSubject()
    
    private static let realm = try! Realm()
    
    static func storeToken(token: String) {
        store(key: DBKeys.apiToken, value: token)
        loginTokenStored.send(true)
    }
    
    static func storeLoginUserId(userId: Int) {
        store(key: DBKeys.loginUserId, value: String(userId))
    }
    
    static func getLoginUserId() -> Int? {
        guard let userId = get(key: DBKeys.loginUserId) else {
            return nil
        }
        return Int(userId)
    }
    
    private static func get(key: String) -> String? {
        return realm.objects(DBKeyValue.self).where { $0.key == key }.first?.value
    }
    
    private static func store(key: String, value: String) {
        let kv = realm.objects(DBKeyValue.self).where { $0.key == key }.first
        if let kv = kv {
            try! realm.write {
                kv.value = value
            }
        } else {
            let newKv = DBKeyValue(key: key, value: value)
            try! realm.write {
                realm.add(newKv)
            }
        }
    }
}
