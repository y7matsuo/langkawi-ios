//
//  LoginSessionManager.swift
//  Langkawi-iOS
//
//  Created by Yuki Matsuo on 2022/09/20.
//

import Combine
import RealmSwift

class LoginSessionManager {
    
    static var loginSessionStored: PassthroughSubject<Bool, Never> = PassthroughSubject()
    
    private static let realm = try! Realm()
    
    static func storeSession(token: String, userId: Int) {
        store(key: DBKeys.apiToken, value: token)
        store(key: DBKeys.loginUserId, value: String(userId))
        loginSessionStored.send(true)
    }
    
    static func deleteSession() {
        delete(key: DBKeys.apiToken)
        delete(key: DBKeys.loginUserId)
        loginSessionStored.send(false)
    }
    
    static func getLoginUserId() -> Int? {
        guard let userId = getValue(key: DBKeys.loginUserId) else {
            return nil
        }
        return Int(userId)
    }
    
    private static func getObject(key: String) -> DBKeyValue? {
        return realm.objects(DBKeyValue.self).where { $0.key == key }.first
    }
    
    private static func getValue(key: String) -> String? {
        return getObject(key: key)?.value
    }
    
    private static func store(key: String, value: String) {
        let kv = getObject(key: key)
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
    
    private static func delete(key: String) {
        guard let obj = getObject(key: key) else {
            return
        }
        try! realm.write {
            realm.delete(obj)
        }
    }
}
