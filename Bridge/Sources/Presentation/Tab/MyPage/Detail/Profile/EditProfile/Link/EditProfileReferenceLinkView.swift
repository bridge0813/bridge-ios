//
//  EditProfileReferenceLinkView.swift
//  Bridge
//
//  Created by 엄지호 on 1/1/24.
//

import UIKit
import FlexLayout
import PinLayout
import RxSwift
import RxCocoa

// TODO: - 상속으로 불필요한 중복제거
/// 프로필 수정에서 참고 링크를 수정하는  뷰
final class EditProfileReferenceLinkView: BaseView {
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
    
    private let placeholderContainer: UIView = {
        let view = UIView()
        view.layer.borderColor = BridgeColor.gray06.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        return view
    }()
    
    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "직무 경험과 관련하여 참고할 수 있는 링크를 입력하세요."
        label.font = BridgeFont.body2.font
        label.textColor = BridgeColor.gray04
        return label
    }()
    
    // MARK: - Property
    var links: [String] = [] {
        didSet {
            // 보여줄 링크가 없을 경우, 플레이스홀더 보여주기.
            tableView.flex.display(links.isEmpty ? .none : .flex)
            placeholderContainer.flex.display(links.isEmpty ? .flex : .none)
            
            // 기존 데이터소스 제거
            tableView.dataSource = nil
            
            // 데이터소스 설정
            Observable.of(links)
                .bind(to: tableView.rx.items(
                    cellIdentifier: ReferenceLinkCell.reuseIdentifier,
                    cellType: ReferenceLinkCell.self
                )) { _, element, cell in
                    cell.configure(with: element, isDeletable: true)
                }
                .disposed(by: disposeBag)
            
            // 컨텐츠 크기 직접 계산 및 설정
            let contentHeight = tableView.rowHeight * CGFloat(links.count)
            tableView.flex.height(contentHeight).markDirty()
            rootFlexContainer.flex.layout()
        }
    }
    
    // MARK: - Layout
    override func configureLayouts() {
        addSubview(rootFlexContainer)
        rootFlexContainer.flex.define { flex in
            flex.addItem(tableView).display(.flex)
            flex.addItem(placeholderContainer).display(.none).height(52).padding(17, 16, 17, 16).define { flex in
                flex.addItem(placeholderLabel)
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        rootFlexContainer.pin.all()
        rootFlexContainer.flex.layout()
    }
}
