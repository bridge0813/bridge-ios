//
//  ProfileReferenceLinkView.swift
//  Bridge
//
//  Created by 엄지호 on 12/29/23.
//

import UIKit
import FlexLayout
import PinLayout
import RxSwift
import RxCocoa

/// 프로필에서 유저의 참고 링크를 보여주는  뷰
final class ProfileReferenceLinkView: BaseView {
    // MARK: - UI
    private let rootFlexContainer = UIView()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ProfileTechStackCell.self)
        tableView.estimatedRowHeight = 0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorInset = .init(top: 0, left: 16, bottom: 0, right: 16)
        tableView.backgroundColor = BridgeColor.gray09
        tableView.layer.borderWidth = 1
        tableView.layer.cornerRadius = 8
        tableView.clipsToBounds = true
        tableView.isScrollEnabled = false
        return tableView
    }()
    
    // MARK: - Property
    var fieldTechStacks: [FieldTechStack] = [] {
        didSet {
            // 유저가 설정한 기술 스택 정보가 있을 경우
            if !fieldTechStacks.isEmpty {
                tableView.backgroundColor = .clear
                tableView.layer.borderColor = BridgeColor.gray06.cgColor
                
                Observable.of(fieldTechStacks)
                    .bind(to: tableView.rx.items(
                        cellIdentifier: ProfileTechStackCell.reuseIdentifier,
                        cellType: ProfileTechStackCell.self
                    )) { _, element, cell in
                        cell.configure(with: element)
                    }
                    .disposed(by: disposeBag)
                
                
                print("컨텐츠 사이즈 \(tableView.contentSize.height)")
                tableView.flex.height(tableView.contentSize.height).markDirty()
                rootFlexContainer.flex.layout()
            }
        }
    }
    
    // MARK: - Layout
    override func configureLayouts() {
        addSubview(rootFlexContainer)
        rootFlexContainer.flex.define { flex in
            flex.addItem(tableView).height(52)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        rootFlexContainer.pin.all()
        rootFlexContainer.flex.layout()
    }
}
