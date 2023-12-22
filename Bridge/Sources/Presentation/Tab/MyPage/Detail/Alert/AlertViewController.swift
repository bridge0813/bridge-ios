//
//  AlertViewController.swift
//  Bridge
//
//  Created by 정호윤 on 12/14/23.
//

import UIKit
import FlexLayout
import PinLayout
import RxCocoa
import RxSwift

final class AlertViewController: BaseViewController {
    // MARK: - UI
    private let removeAllButton: UIButton = {
        let button = UIButton()
        button.setTitle("전체 삭제", for: .normal)
        button.setTitleColor(BridgeColor.primary1, for: .normal)
        button.titleLabel?.font = BridgeFont.body2.font
        return button
    }()
    
    private lazy var alertListTableView: UITableView = {
        let tableView = UITableView()
//        tableView.register()
        tableView.rowHeight = 120
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = .zero
        return tableView
    }()
    
    // MARK: - Property
    private let viewModel: AlertViewModel
    private let removeAlert = PublishRelay<Int>()
    
    // MARK: - Init
    init(viewModel: AlertViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: - Configuration
    override func configureAttributes() {
        navigationItem.title = "알림"
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: removeAllButton)
    }
    
    // MARK: - Layout
    override func configureLayouts() {
        view.addSubview(alertListTableView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        alertListTableView.pin.all(view.pin.safeArea)
        alertListTableView.flex.layout()
    }
    
    // MARK: - Binding
    override func bind() {
        let input = AlertViewModel.Input()
        let output = viewModel.transform(input: input)
    }
}

// MARK: - Delegate
extension AlertViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "삭제") { [weak self] _, _, completion in
            self?.removeAlert.accept(indexPath.row)
            completion(true)
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
