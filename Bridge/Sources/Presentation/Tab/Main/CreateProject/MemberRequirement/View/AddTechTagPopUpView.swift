//
//  AddTechTagPopUpView.swift
//  Bridge
//
//  Created by 엄지호 on 2023/10/27.
//

import UIKit
import FlexLayout
import PinLayout
import RxSwift
import RxCocoa

/// 기술스택을 추가하는 뷰
final class AddTechTagPopUpView: BridgeBasePopUpView {
    // MARK: - UI
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: configureLayout())
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(TechTagCell.self)
        
        return collectionView
    }()
    
    // MARK: - Property
    override var containerHeight: CGFloat { 576 }
    override var dismissYPosition: CGFloat { 300 }
    
    /// 데이터소스
    let fieldUpdated = PublishSubject<[String]>()
    
    private var selectedTags: [String] = []     // 선택한 기술태그를 저장
    
    var completeButtonTapped: Observable<[String]> {
        return completeButton.rx.tap
            .withUnretained(self)
            .map { owner, _ in
                owner.hide()
                return owner.selectedTags
            }
            .distinctUntilChanged()
            .share()
    }
    
    // MARK: - Configuration
    override func configureAttributes() {
        super.configureAttributes()
        titleLabel.text = "스택"
        addTapGestureForHide()
    }
    
    // MARK: - Layout
    override func configureLayouts() {
        super.configureLayouts()
        
        rootFlexContainer.flex.define { flex in
            flex.addItem(dragHandleBar).alignSelf(.center).marginTop(10)
            
            flex.addItem(titleLabel).width(32).height(22).marginTop(30).marginLeft(16)
            
            flex.addItem().backgroundColor(BridgeColor.gray08).height(1).marginTop(7)
            
            flex.addItem(collectionView).grow(1).marginTop(30).marginHorizontal(16)
            
            flex.addItem().height(25)
            flex.addItem(completeButton).height(52).marginHorizontal(16).marginBottom(47)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    // MARK: - Binding
    override func bind() {
        // 데이터소스 설정
        fieldUpdated
            .bind(to: collectionView.rx.items(
                cellIdentifier: TechTagCell.reuseIdentifier,
                cellType: TechTagCell.self
            )) { [weak self] _, element, cell in
                guard let self else { return }
                
                cell.configure(tagName: element, cornerRadius: 4)
                
                cell.tagButtonTapped
                    .withUnretained(self)
                    .bind(onNext: { owner, tagName in
                        if let index = owner.selectedTags.firstIndex(of: tagName) {
                            owner.selectedTags.remove(at: index)
                        } else {
                            owner.selectedTags.append(tagName)
                        }
                        
                        owner.completeButton.isEnabled = !owner.selectedTags.isEmpty
                    })
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - CompositionalLayout
extension AddTechTagPopUpView {
    private func configureLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .estimated(130),
            heightDimension: .absolute(38)
        )

        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(38)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(14)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 14
        
        return UICollectionViewCompositionalLayout(section: section)
    }
}
