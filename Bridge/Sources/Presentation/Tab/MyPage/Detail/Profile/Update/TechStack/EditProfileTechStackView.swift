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
final class EditProfileTechStackListView: BaseListView {
    // MARK: - UI
    private let fieldTechStackPickerView = FieldTechStackPickerPopUpView()  // 수정용
    
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
    
    private var indexRow: IndexRow = 0
    let deletedFieldTechStack = PublishSubject<IndexRow>()                    // 인덱스에 맞는 스택 삭제
    let updatedFieldTechStack = PublishSubject<(IndexRow, FieldTechStack)>()  // 인덱스에 맞는 스택 수정
    
    // MARK: - Configuration
    override func configureAttributes() {
        tableView.register(EditProfileTechStackCell.self)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 160
        tableView.separatorStyle = .none
        tableView.layer.cornerRadius = 8
        tableView.clipsToBounds = true
        tableView.isScrollEnabled = true
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
        fieldTechStacksUpdated
            .bind(to: tableView.rx.items(
                cellIdentifier: EditProfileTechStackCell.reuseIdentifier,
                cellType: EditProfileTechStackCell.self
            )) { indexRow, element, cell in
                cell.configure(with: element)
                cell.indexRow = indexRow
                
                cell.dropdownItemSelected
                    .withUnretained(self)
                    .subscribe(onNext: { owner, item in
                        let (option, indexRow) = item
                        
                        if option == "삭제하기" {
                            owner.deletedFieldTechStack.onNext(indexRow)
                        } else {
                            // 수정하기
                            owner.indexRow = indexRow
                            owner.fieldTechStackPickerView.show()
                        }
                    })
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
        
        fieldTechStackPickerView.selectedFieldTechStack
            .withUnretained(self)
            .subscribe(onNext: { owner, fieldTechStack in
                owner.updatedFieldTechStack.onNext((owner.indexRow, fieldTechStack))
            })
            .disposed(by: disposeBag)
    }
}
