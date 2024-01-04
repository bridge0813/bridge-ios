//
//  ProfileTechStackView.swift
//  Bridge
//
//  Created by 엄지호 on 12/27/23.
//

import UIKit
import FlexLayout
import PinLayout
import RxSwift
import RxCocoa

/// 프로필에서 유저의 기술 스택을 보여주는  뷰
final class ProfileTechStackView: BaseView {
    // MARK: - UI
    private let rootFlexContainer = UIView()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ProfileTechStackCell.self)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 140
        tableView.separatorInset = .init(top: 0, left: 16, bottom: 0, right: 16)
        tableView.layer.cornerRadius = 8
        tableView.clipsToBounds = true
        return tableView
    }()
    
    // MARK: - Property
    private let fieldTechStacksUpdated = PublishSubject<[FieldTechStack]>()
    
    var fieldTechStacks: [FieldTechStack] = [] {
        didSet {
            tableView.backgroundColor = fieldTechStacks.isEmpty ? BridgeColor.gray09 : .clear
            tableView.layer.borderColor = fieldTechStacks.isEmpty ? nil : BridgeColor.gray06.cgColor
            tableView.layer.borderWidth = fieldTechStacks.isEmpty ? .zero : 1
            
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
                cellIdentifier: ProfileTechStackCell.reuseIdentifier,
                cellType: ProfileTechStackCell.self
            )) { _, element, cell in
                cell.configure(with: element)
            }
            .disposed(by: disposeBag)
    }
}
