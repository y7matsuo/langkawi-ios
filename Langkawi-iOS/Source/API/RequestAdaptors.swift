//
//  RequestAdaptors.swift
//  Langkawi-iOS
//
//  Created by Yuki Matsuo on 2022/09/11.
//

import Alamofire
import RealmSwift

class AuthorizationAdaptor: Adapter {
    
    static let shared = AuthorizationAdaptor()
    
    private static let authorization = "Authorization"
    private static let bearer = "Bearer"
    
    init() {
        let handler: (URLRequest, Session, _ completion: @escaping (Result<URLRequest, Error>) -> Void) -> Void = { (request, session, completion) -> Void in
            var request = request
            let realm = try! Realm()
            let kv = realm.objects(DBKeyValue.self).where { $0.key == DBKeys.apiToken }.first
            guard let kv = kv else {
                completion(.success(request))
                return
            }
            
            request.headers.add(name: AuthorizationAdaptor.authorization, value: "\(AuthorizationAdaptor.bearer) \(kv.value)")
            completion(.success(request))
        }
        super.init(handler)
    }
}

extension Dictionary where Key == String, Value == Any? {
    
    func compactParameters() -> Parameters {
        var parameters: Parameters = [:]
        self.forEach { kv in
            if let value = kv.value {
                parameters[kv.key] = value
            }
        }
        return parameters
    }
}
