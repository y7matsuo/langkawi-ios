//
//  TalkRoomViewController.swift
//  Langkawi-iOS
//
//  Created by Yuki Matsuo on 2022/09/30.
//

import UIKit
import Combine

class TalkRoomViewController: BaseViewController {
    private lazy var vm = TalkRoomViewModel(owner: self)
    
    private let cellIdentifier = "talkRoom"
    
    private var tableView: UITableView?
    
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        vm.setup()
        sink()
        layoutNavigationBar()
        layout()
        super.viewDidLoad()
    }
    
    private func layoutNavigationBar() {
        navigationItem.title = LabelDef.talkRoom
        navigationItem.backButtonTitle = LabelDef.back
        layoutNavigationBarBorder()
    }
    
    private func layout() {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.register(TalkRoomCell.self, forCellReuseIdentifier: cellIdentifier)
        self.tableView = tableView
        
        view.addSubviewForAutoLayout(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func sink() {
        vm.talkRooms.sink { [weak self] in
            guard $0.count > 0 else {
                return
            }
            self?.tableView?.reloadData()
        }.store(in: &cancellables)
    }
}

extension TalkRoomViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.talkRooms.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? TalkRoomCell else {
            return
        }
        cell.owner = self
        cell.talkRoom = vm.talkRooms.value[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
}
