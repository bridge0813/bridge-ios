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
        tableView.register(ReferenceLinkCell.self)
        tableView.rowHeight = 60
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        return tableView
    }()
    
    // MARK: - Property
    var links: [String] = [] {
        didSet {
            // 보여줄 링크가 없을 경우, 플레이스홀더 텍스트
            let emptyPlaceholder = ["직무 경험과 관련하여 참고할 수 있는 링크를 입력하세요."]
            
            Observable.of(links.isEmpty ? emptyPlaceholder : links)
                .bind(to: tableView.rx.items(
                    cellIdentifier: ReferenceLinkCell.reuseIdentifier,
                    cellType: ReferenceLinkCell.self
                )) { _, element, cell in
                    cell.configure(with: element)
                }
                .disposed(by: disposeBag)
            
            tableView.flex.height(tableView.contentSize.height).markDirty()
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
}
