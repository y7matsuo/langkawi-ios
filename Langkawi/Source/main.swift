//
//  main.swift
//  Langkawi
//
//  Created by 松尾 勇気（Yuki Matsuo） on 2022/10/23.
//  Copyright © 2022 y7matsuo. All rights reserved.
//

import UIKit

let isRunningTests = NSClassFromString("XCTestCase") != nil

let appDelegaeClassString: String
if isRunningTests {
    appDelegaeClassString = NSStringFromClass(UnitTestsAppDelegate.self)
} else {
    appDelegaeClassString = NSStringFromClass(AppDelegate.self)
}

UIApplicationMain(CommandLine.argc, CommandLine.unsafeArgv, nil, appDelegaeClassString)
