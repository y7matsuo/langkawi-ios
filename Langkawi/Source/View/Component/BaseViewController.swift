//
//  BaseViewController.swift
//  Langkawi-iOS
//
//  Created by Yuki Matsuo on 2022/09/15.
//

import Foundation
import UIKit

class BaseViewController:
    LifecycleInjectableViewController,
    UseEffectSupport,
    APIHandler {}

typealias OwnerVC = UseEffectSupport & APIHandler
