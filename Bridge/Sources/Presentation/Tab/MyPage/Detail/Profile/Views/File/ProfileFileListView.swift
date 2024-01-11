//
//  ProfileReferenceFileView.swift
//  Bridge
//
//  Created by 엄지호 on 12/30/23.
//

import UIKit
import FlexLayout
import PinLayout
import RxSwift
import RxCocoa

/// 프로필에서 유저의 참고 링크를 보여주는  뷰
final class ProfileFileListView: BaseListView {
    // MARK: - Property
    private var isDeletable: Bool
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
    
    /// 파일 선택(보여주기)
    var selectedFile: Observable<ReferenceFile> {
        tableView.rx.modelSelected(ReferenceFile.self).asObservable()
    }
    
    /// 파일 삭제
    let deletedFile = PublishSubject<IndexRow>()
    
    // MARK: - Init
    /// - Parameter isDeletable: 파일 삭제 가능에 대한 여부를 나타냅니다.
    init(isDeletable: Bool) {
        self.isDeletable = isDeletable
        super.init(frame: .zero)
    }
    
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
            )) { [weak self] indexRow, element, cell in
                guard let self else { return }
                
                cell.configure(with: element, isDeletable: self.isDeletable)
                
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
