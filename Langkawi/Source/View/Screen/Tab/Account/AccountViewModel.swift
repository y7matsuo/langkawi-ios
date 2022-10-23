//
//  AccountViewModel.swift
//  Langkawi-iOS
//
//  Created by Yuki Matsuo on 2022/09/22.
//

import UIKit
import Combine

class AccountViewModel {
    @Published var avator: UIImage = UIImage()
    @Published var name: String = ""
    @Published var gender: String = ""
    @Published var genderColor: UIColor = .black
    @Published var age: String = ""
    @Published var description: String = ""
}
