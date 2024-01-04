//
//  EditProfileTechStackView.swift
//  Bridge
//
//  Created by 엄지호 on 1/1/24.
//

import UIKit
import FlexLayout
import PinLayout
import RxSwift
import RxCocoa

/// 프로필 수정에서 유저의 기술 스택을 수정하는 뷰
final class EditProfileTechStackView: BaseView {
    // MARK: - UI
    private let rootFlexContainer = UIView()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(EditProfileTechStackCell.self)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 160
        tableView.separatorStyle = .none
        tableView.layer.cornerRadius = 8
        tableView.clipsToBounds = true
        return tableView
    }()
    
    // MARK: - Property
    private let fieldTechStacksUpdated = PublishSubject<[FieldTechStack]>()
    
    var fieldTechStacks: [FieldTechStack] = [] {
        didSet {
            tableView.backgroundColor = fieldTechStacks.isEmpty ? BridgeColor.gray09 : .clear
            fieldTechStacksUpdated.onNext(fieldTechStacks)
            
            // 컨텐츠 크기 직접 계산 및 설정
            let contentHeight = tableView.rowHeight * CGFloat(fieldTechStacks.count)
            tableView.flex.height(fieldTechStacks.isEmpty ? 52 : contentHeight).markDirty()
            rootFlexContainer.flex.layout()
        }
    }
    
    // MARK: - Layout
    override func configureLayouts() {
        addSubview(rootFlexContainer)
        rootFlexContainer.flex.define { flex in
            flex.addItem(tableView)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        rootFlexContainer.pin.all()
        rootFlexContainer.flex.layout()
    }
    
    // MARK: - Binding
    override func bind() {
        // 데이터소스 설정
        fieldTechStacksUpdated
            .bind(to: tableView.rx.items(
                cellIdentifier: EditProfileTechStackCell.reuseIdentifier,
                cellType: EditProfileTechStackCell.self
            )) { _, element, cell in
                cell.configure(with: element)
            }
            .disposed(by: disposeBag)
    }
}
