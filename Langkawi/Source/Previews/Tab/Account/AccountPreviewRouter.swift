//
//  AccountPreviewRouter.swift
//  Langkawi-iOS
//
//  Created by 松尾 勇気（Yuki Matsuo） on 2022/10/11.
//

import UIKit

class AccountPreviewRouter: PreviewRouter {
    
    class AccountPresenter: AccountPresentation {
        func fetchAccount() {}
        func showEditName() {}
        func showEditDescription() {}
    }

    func assemble() -> UIViewController {
        let vm = AccountViewModel()
        let view = AccountViewController(vm: vm, presenter: AccountPresenter())
        vm.avator = UIImage(named: "AvatorMan") ?? UIImage()
        vm.name = "松尾 勇気"
        vm.gender = "男性"
        vm.genderColor = .blue
        vm.age = "39歳"
        vm.description = "巡回かおつきこくふくする。かいころく川底そんけい。せいぞう盛り上がるやすい。いっかいずいぶんばい。せっとく野獣あい。冬休みしょうじょういち。碁じどうし靖国神社。"
        return view
    }
}
