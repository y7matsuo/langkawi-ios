//
//  ImageAPI.swift
//  Langkawi-iOS
//
//  Created by Yuki Matsuo on 2022/09/15.
//

import Combine
import UIKit

protocol ImageAPI {
    
    func getUserDetailPictureA(userId: Int) -> AnyPublisher<UIImage, Error>
}

class ImageAPIImpl: BaseAPI, ImageAPI {
    
    func getUserDetailPictureA(userId: Int) -> AnyPublisher<UIImage, Error> {
        return getImage(path: "/user_detail/picture_a/\(userId)/image.png")
    }
}
