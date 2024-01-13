//
//  FieldTechStackPickerPopUpView.swift
//  Bridge
//
//  Created by 엄지호 on 1/2/24.
//

import UIKit
import FlexLayout
import PinLayout
import RxSwift
import RxCocoa

/// 분야와 기술스택을 선택하는 뷰
final class FieldTechStackPickerPopUpView: BridgeBasePopUpView {
    // MARK: - UI
    private let fieldTabButton: BridgeTabButton = {
        let button = BridgeTabButton(title: "분야", titleFont: BridgeFont.subtitle1.font)
        button.flex.width(32).height(22)
        button.configuration?.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
        button.isSelected = true
        return button
    }()
    
    private let stackTabButton: BridgeTabButton = {
        let button = BridgeTabButton(title: "스택", titleFont: BridgeFont.subtitle1.font)
        button.flex.width(32).height(22)
        button.configuration?.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
        return button
    }()
    
    private let underlineBar: UIView = {
        let view = UIView()
        view.flex.width(32).height(2)
        view.backgroundColor = BridgeColor.gray01
        return view
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.flex.height(400)
        scrollView.isScrollEnabled = false  // 유저가 직접 스크롤하는 것을 방지
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    // 분야 선택
    private let setFieldView: BridgeSetFieldView = {
        let view = BridgeSetFieldView()
        view.flex.width(100%).height(100%)
        return view
    }()
    
    // 스택 선택
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: configureLayout())
        collectionView.flex.width(100%).height(100%)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(TechTagCell.self)
        return collectionView
    }()
    
    // MARK: - Property
    override var containerHeight: CGFloat { 576 }
    override var dismissYPosition: CGFloat { 300 }
    
    private var fieldTechStack = FieldTechStack(field: "", techStacks: [])
    
    var selectedFieldTechStack: Observable<FieldTechStack> {
        return completeButton.rx.tap
            .withUnretained(self)
            .map { owner, _ in
                owner.hide()
                return owner.fieldTechStack
            }
    }
    
    // MARK: - Configuration
    override func configureAttributes() {
        super.configureAttributes()
        completeButton.isHidden = true
    }
    
    // MARK: - Layout
    override func configureLayouts() {
        super.configureLayouts()
        
        rootFlexContainer.flex.paddingHorizontal(16).define { flex in
            flex.addItem(dragHandleBar).alignSelf(.center).marginTop(10)
            
            flex.addItem().marginTop(30).height(31).define { flex in
                flex.addItem().direction(.row).define { flex in
                    flex.addItem(fieldTabButton)
                    flex.addItem(stackTabButton).marginLeft(20)
                }
                
                flex.addItem(underlineBar).marginTop(7)
            }
            
            flex.addItem().backgroundColor(BridgeColor.gray08).height(1).marginHorizontal(-16)
            
            flex.addItem(scrollView).direction(.row).marginTop(32).define { flex in
                flex.addItem(setFieldView)
                flex.addItem(collectionView)
            }
            
            flex.addItem(completeButton).height(52).marginTop(25)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        scrollView.contentSize.width = scrollView.frame.size.width * 2
    }
    
    // MARK: - Binding
    override func bind() {
        fieldTabButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.scrollToFieldTab()
            })
            .disposed(by: disposeBag)
        
        stackTabButton.rx.tap
            .withUnretained(self)
            .filter { owner, _ in !owner.fieldTechStack.field.isEmpty }  // 분야가 선택되지 않았을 경우에는 이동 불가.
            .subscribe(onNext: { owner, _ in
                owner.scrollToStackTab()
            })
            .disposed(by: disposeBag)
        
        let fieldUpdated = PublishSubject<[String]>()
        
        // 분야 선택
        setFieldView.fieldTagButtonTapped
            .withUnretained(self)
            .subscribe(onNext: { owner, field in
                let fieldName = field.convertToDisplayFormat()
                
                owner.fieldTechStack.field = fieldName  // 선택한 분야 저장
                owner.fieldTechStack.techStacks = []    // 기술스택 초기화
                
                // 버튼 선택 상태 업데이트
                owner.setFieldView.updateButtonState(field)
                owner.completeButton.isEnabled = false
                
                // data 전달
                fieldUpdated.onNext(TechStack(rawValue: fieldName)?.techStacks ?? [])
                
                // 탭 전환
                owner.scrollToStackTab()
            })
            .disposed(by: disposeBag)
        
        // DataSource 바인딩
        fieldUpdated
            .bind(
                to: collectionView.rx.items(
                    cellIdentifier: TechTagCell.reuseIdentifier,
                    cellType: TechTagCell.self
                )
            ) { _, element, cell in
                
                cell.configure(tagName: element, cornerRadius: 4)
                
                cell.tagButtonTapped
                    .bind(onNext: { [weak self] tagName in
                        guard let self else { return }
                        
                        if let index = self.fieldTechStack.techStacks.firstIndex(of: tagName) {
                            self.fieldTechStack.techStacks.remove(at: index)
                        } else {
                            self.fieldTechStack.techStacks.append(tagName)
                        }
                        
                        self.completeButton.isEnabled = !self.fieldTechStack.techStacks.isEmpty
                    })
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - Show & Hide
    override func show() {
        // 초기화
        fieldTechStack = FieldTechStack(field: "", techStacks: [])
        setFieldView.updateButtonState("")
        super.show()
    }
    
    override func hide() {
        super.hide()
        scrollToFieldTab()  // 기존 탭으로 이동
    }
}

// MARK: - Methods
extension FieldTechStackPickerPopUpView {
    /// 분야 선택 탭으로 이동
    private func scrollToFieldTab() {
        // 탭 전환
        fieldTabButton.isSelected = true
        stackTabButton.isSelected = false
        
        // 스크롤 이동
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        
        // 레이아웃 수정
        scrollView.flex.height(400).markDirty()
        completeButton.isHidden = true
        
        // 언더 바 이동
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            guard let self else { return }
            self.underlineBar.flex.marginLeft(0).markDirty()
            self.rootFlexContainer.flex.layout()
        })
    }
    
    /// 스택 선택 탭으로 이동
    private func scrollToStackTab() {
        // 탭 전환
        fieldTabButton.isSelected = false
        stackTabButton.isSelected = true
        
        // 스크롤 이동
        let collectionViewOffset = CGPoint(x: scrollView.frame.size.width, y: 0)
        scrollView.setContentOffset(collectionViewOffset, animated: true)
        
        // 레이아웃 수정
        scrollView.flex.height(350).markDirty()
        completeButton.isHidden = false
        
        // 언더 바 이동
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            guard let self else { return }
            self.underlineBar.flex.marginLeft(52).markDirty()
            self.rootFlexContainer.flex.layout()
        })
    }
    
    
}

// MARK: - CompositionalLayout
extension FieldTechStackPickerPopUpView {
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
