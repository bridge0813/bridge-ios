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
final class ProfileLinkListView: BaseListView {
    // MARK: - Property
    private var isDeletable: Bool
    private let linksUpdated = PublishSubject<[String]>()
    
    /// 링크 리스트
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
    
    /// 링크 선택(이동)
    var selectedLinkURL: Observable<String> {
        tableView.rx.modelSelected(String.self).asObservable()
    }
    
    /// 링크 삭제
    let deletedLinkURL = PublishSubject<IndexRow>()
    
    // MARK: - Init
    /// - Parameter isDeletable: 링크 삭제 가능에 대한 여부를 나타냅니다.
    init(isDeletable: Bool) {
        self.isDeletable = isDeletable
        super.init(frame: .zero)
    }
    
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
            )) { [weak self] indexRow, element, cell in
                guard let self else { return }
                
                cell.configure(with: element, isDeletable: self.isDeletable)
                
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
