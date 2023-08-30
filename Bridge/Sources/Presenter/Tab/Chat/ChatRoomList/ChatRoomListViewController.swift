//
//  ChatRoomListViewController.swift
//  Bridge
//
//  Created by 정호윤 on 2023/08/26.
//

import UIKit
import RxCocoa
import RxSwift

final class ChatRoomListViewController: UIViewController {
    
    let viewModel: ChatRoomListViewModel
    
    init(viewModel: ChatRoomListViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)  // 얘도 수정...
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBlue
    }
}
