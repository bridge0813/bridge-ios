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
final class EditProfileReferenceFileView: BaseListView {
    // MARK: - Property
    private let filesUpdated = PublishSubject<[ReferenceFile]>()
    
    var files: [ReferenceFile] = [] {
        didSet {
            // 보여줄 파일이 없을 경우, 플레이스홀더 보여주기.
            tableView.flex.display(files.isEmpty ? .none : .flex)
            placeholderContainer.flex.display(files.isEmpty ? .flex : .none)
            
            filesUpdated.onNext(files)
            
            // 컨텐츠 크기 직접 계산 및 설정
            let contentHeight = tableView.rowHeight * CGFloat(files.count)
            tableView.flex.height(contentHeight).markDirty()
            rootFlexContainer.flex.layout()
        }
    }
    
    let deletedFile = PublishSubject<IndexRow>()
    
    // MARK: - Configuration
    override func configureAttributes() {
        tableView.register(ReferenceFileCell.self)
        placeholderLabel.text = "직무와 관련한 첨부파일을 추가해보세요."
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
        filesUpdated
            .bind(to: tableView.rx.items(
                cellIdentifier: ReferenceFileCell.reuseIdentifier,
                cellType: ReferenceFileCell.self
            )) { indexRow, element, cell in
                cell.configure(with: element, isDeletable: true)
                cell.indexRow = indexRow
                cell.deleteButtonTapped
                    .withUnretained(self)
                    .subscribe(onNext: { owner, indexRow in
                        owner.deletedFile.onNext(indexRow)
                    })
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
    }
}
