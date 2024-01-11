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

/// 프로필 수정에서 참고 링크를 수정하는  뷰
final class EditProfileLinkListView: BaseListView {
    // MARK: - Property
    private let linksUpdated = PublishSubject<[String]>()
    
    var links: [String] = [] {
        didSet {
            // 보여줄 링크가 없을 경우, 플레이스홀더 보여주기.
            tableView.flex.display(links.isEmpty ? .none : .flex)
            placeholderContainer.flex.display(links.isEmpty ? .flex : .none)
            
            linksUpdated.onNext(links)
            
            // 컨텐츠 크기 직접 계산 및 설정
            let contentHeight = tableView.rowHeight * CGFloat(links.count)
            tableView.flex.height(contentHeight).markDirty()
            rootFlexContainer.flex.layout()
        }
    }
    
    let deletedLinkURL = PublishSubject<IndexRow>()
    
    // MARK: - Configuration
    override func configureAttributes() {
        tableView.register(ReferenceLinkCell.self)
        placeholderLabel.text = "직무 경험과 관련하여 참고할 수 있는 링크를 입력하세요."
    }
    
    // MARK: - Layout
    override func configureLayouts() {
        super.configureLayouts()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    // MARK: - Binding
    override func bind() {
        // 데이터소스 설정
        linksUpdated
            .bind(to: tableView.rx.items(
                cellIdentifier: ReferenceLinkCell.reuseIdentifier,
                cellType: ReferenceLinkCell.self
            )) { indexRow, element, cell in
                cell.configure(with: element, isDeletable: true)
                cell.indexRow = indexRow
                cell.deleteButtonTapped
                    .withUnretained(self)
                    .subscribe(onNext: { owner, indexRow in
                        owner.deletedLinkURL.onNext(indexRow)
                    })
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
    }
}
