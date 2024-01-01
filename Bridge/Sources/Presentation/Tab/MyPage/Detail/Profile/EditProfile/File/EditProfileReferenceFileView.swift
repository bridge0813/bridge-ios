//
//  EditProfileReferenceFileView.swift
//  Bridge
//
//  Created by 엄지호 on 1/2/24.
//

import UIKit
import FlexLayout
import PinLayout
import RxSwift
import RxCocoa

/// 프로필 수정에서 첨부파일을 수정하는  뷰
final class EditProfileReferenceFileView: BaseView {
    // MARK: - UI
    private let rootFlexContainer = UIView()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ReferenceFileCell.self)
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
        label.text = "직무와 관련한 첨부파일을 추가해보세요."
        label.font = BridgeFont.body2.font
        label.textColor = BridgeColor.gray04
        return label
    }()
    
    // MARK: - Property
    var files: [ReferenceFile] = [] {
        didSet {
            // 보여줄 파일이 없을 경우, 플레이스홀더 보여주기.
            tableView.flex.display(files.isEmpty ? .none : .flex)
            placeholderContainer.flex.display(files.isEmpty ? .flex : .none)
            
            // 기존 데이터소스 제거
            tableView.dataSource = nil
            
            // 데이터소스 설정
            Observable.of(files)
                .bind(to: tableView.rx.items(
                    cellIdentifier: ReferenceFileCell.reuseIdentifier,
                    cellType: ReferenceFileCell.self
                )) { _, element, cell in
                    cell.configure(with: element, isDeletable: true)
                }
                .disposed(by: disposeBag)
            
            // 컨텐츠 크기 직접 계산 및 설정
            let contentHeight = tableView.rowHeight * CGFloat(files.count)
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
