//
//  BaseAPI.swift
//  Langkawi-iOS
//
//  Created by Yuki Matsuo on 2022/08/31.
//

import Foundation
import Alamofire
import Combine

class BaseAPI {
    
    private let basePath = "http://localhost:3000"
    private lazy var apiPath = "\(basePath)/api"
    private lazy var imagePath = "\(basePath)/uploads"
    
    func getRequest<T: Decodable>(
        path: String,
        model: T.Type,
        parameters: Parameters? = nil,
        interceptor: RequestInterceptor? = AuthorizationAdaptor.shared
    ) -> AnyPublisher<T, Error> {
        return request(
            path: path,
            model: model,
            method: .get,
            parameters: parameters,
            encoding: URLEncoding.default,
            interceptor: interceptor
        )
    }
    
    func postRequest<T: Decodable>(
        path: String,
        model: T.Type,
        parameters: Parameters? = nil,
        interceptor: RequestInterceptor? = AuthorizationAdaptor.shared
    ) -> AnyPublisher<T, Error> {
        return request(
            path: path,
            model: model,
            method: .post,
            parameters: parameters,
            encoding: JSONEncoding.default,
            interceptor: interceptor
        )
    }
    
    func putRequest<T: Decodable>(
        path: String,
        model: T.Type,
        parameters: Parameters? = nil,
        interceptor: RequestInterceptor? = AuthorizationAdaptor.shared
    ) -> AnyPublisher<T, Error> {
        return request(
            path: path,
            model: model,
            method: .put,
            parameters: parameters,
            encoding: JSONEncoding.default,
            interceptor: interceptor
        )
    }
    
    func deleteRequest<T: Decodable>(
        path: String,
        model: T.Type,
        parameters: Parameters? = nil,
        interceptor: RequestInterceptor? = AuthorizationAdaptor.shared
    ) -> AnyPublisher<T, Error> {
        return request(
            path: path,
            model: model,
            method: .delete,
            parameters: parameters,
            encoding: JSONEncoding.default,
            interceptor: interceptor
        )
    }
    
    private func request<T: Decodable>(
        path: String,
        model: T.Type,
        method: HTTPMethod,
        parameters: Parameters?,
        encoding: ParameterEncoding,
        headers: HTTPHeaders? = nil,
        interceptor: RequestInterceptor? = nil
    ) -> AnyPublisher<T, Error> {
        return AF.request(
            "\(apiPath)\(path)",
            method: method, parameters: parameters, encoding: encoding, headers: headers, interceptor: interceptor
        ).publishData()
            .tryMap { (dr: DataResponse<Data, AFError>) -> T in
                switch dr.result {
                case .success(let data):
                    guard let status = dr.response?.statusCode else {
                        throw AFError.responseSerializationFailed(reason: .invalidEmptyResponse(type: "empty"))
                    }
                    
                    let df = DateFormatter()
                    df.dateFormat = LabelDef.dateFormat
                    df.timeZone = .init(identifier: "UTC")
                    
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    decoder.dateDecodingStrategy = .formatted(df)
                    
                    do {
                        if status == 200 {
                            return try decoder.decode(model, from: data)
                        } else {
                            let resp = try decoder.decode(ErrorResponse.self, from: data)
                            throw APIStatusError(status: status, response: resp)
                        }
                    } catch {
                        if let error = error as? APIStatusError {
                            throw error
                        }
                        throw AFError.responseSerializationFailed(reason: .decodingFailed(error: error))
                    }
                case .failure(let error):
                    throw error
                }
            }.eraseToAnyPublisher()
    }
    
    func getImage(path: String) -> AnyPublisher<UIImage, Error> {
        return AF.request("\(imagePath)\(path)", method: .get).publishData()
            .tryMap { (dr: DataResponse<Data, AFError>) -> UIImage in
                switch dr.result {
                case .success(let data):
                    guard let status = dr.response?.statusCode else {
                        throw AFError.responseSerializationFailed(reason: .invalidEmptyResponse(type: "empty"))
                    }
                    
                    if status == 200 {
                        return UIImage(data: data) ?? UIImage()
                    } else {
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        let errorResponse = try decoder.decode(ErrorResponse.self, from: data)
                        throw APIStatusError(status: status, response: errorResponse)
                    }
                case .failure(let error):
                    throw error
                }
            }.eraseToAnyPublisher()
    }
}
