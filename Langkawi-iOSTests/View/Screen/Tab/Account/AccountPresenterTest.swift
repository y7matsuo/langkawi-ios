//
//  AccountPresenterTest.swift
//  Langkawi-iOSTests
//
//  Created by 松尾 勇気（Yuki Matsuo） on 2022/10/14.
//

import XCTest
@testable import Langkawi_iOS

class AccountPresenterTest: XCTestCase {
    private var vm: AccountViewModel!
    private var interactor: AccountUseCaseMock!
    private var router: AccountWireframeMock!
    private var presenter: AccountPresenter!
    
    override func setUp() {
        vm = AccountViewModel()
        interactor = AccountUseCaseMock()
        router = AccountWireframeMock()
        presenter = AccountPresenter(vm: vm, interactor: interactor, router: router)
    }
    
    func testFetchAccount() {
        interactor.getUserIdHandler = { nil }
        presenter.fetchAccount()
        assert(interactor.fetchAvatorCallCount == 0)
        assert(interactor.fetchUserCallCount == 0)
        
        interactor.getUserIdHandler = { 1 }
        presenter.fetchAccount()
        assert(interactor.fetchAvatorCallCount == 1)
        assert(interactor.fetchUserCallCount == 1)
    }
    
    func testShowEditName() {
        presenter.showEditName()
        assert(router.presentEditNameCallCount == 1)
    }
    
    func testShowEditDescription() {
        presenter.showEditDescription()
        assert(router.presentEditDescriptionCallCount == 1)
    }
    
    func testOnFetchUser() {
        let user = TestData.user
        presenter.onFetchUser(user: user)
        assert(vm.name == user.toNameLabelText())
        assert(vm.gender == user.toGenderText())
        assert(vm.genderColor == user.toGenderColor())
        assert(vm.age == user.toAgeLabelText())
        assert(vm.description == user.detail?.descriptionA)
    }
    
    func testOnFetchAvator() {
        let image = UIImage()
        presenter.onFetchAvator(image: image)
        assert(vm.avator == image)
    }
}
