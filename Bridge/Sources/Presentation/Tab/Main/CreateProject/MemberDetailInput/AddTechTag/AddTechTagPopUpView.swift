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
    
    // MARK: - Properties
    override var containerHeight: CGFloat { 576 }
    override var dismissYPosition: CGFloat { 300 }
    
    /// 선택된 분야를 전달받으면
    /// willSet - 데이터소스를 결정 할 타입을 저장
    /// didSet - 데이터소스를 바인딩하여 CollectionView Cell을 구현(CollectionViewDataSource 역할)
    var field = String() {
        didSet {
            Observable.of(TechStack(rawValue: field)?.techStacks ?? [])
                .bind(
                    to: collectionView.rx.items(
                        cellIdentifier: TechTagCell.reuseIdentifier,
                        cellType: TechTagCell.self
                    )
                ) { [weak self] _, tagName, cell in
                    guard let self else { return }
                
                    cell.tagButton.updateTitle(with: tagName)
                    cell.tagButton.layer.cornerRadius = 4
                    cell.configureLayout()
                    
                    cell.tagButton.rx.tap
                        .map { cell.tagButton.titleLabel?.text ?? String() }
                        .withUnretained(self)
                        .bind(onNext: { owner, tag in
                            if let index = owner.selectedTags.firstIndex(of: tag) {
                                owner.selectedTags.remove(at: index)
                            } else {
                                owner.selectedTags.append(tag)
                            }
                            
                            owner.completeButton.isEnabled = !owner.selectedTags.isEmpty
                        })
                        .disposed(by: cell.disposeBag)
                }
                .disposed(by: disposeBag)
        }
    }
    
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
    
    // MARK: - Layout
    override func configureLayouts() {
        super.configureLayouts()
        
        rootFlexContainer.flex.define { flex in
            flex.addItem(dragHandleBar).alignSelf(.center).width(27).height(5).marginTop(10)
            
            flex.addItem(titleLabel).width(32).height(22).marginTop(30).marginLeft(16)
            
            flex.addItem().backgroundColor(BridgeColor.gray8).height(1).marginTop(7)
            
            flex.addItem(collectionView).grow(1).marginTop(30).marginHorizontal(16)
            
            flex.addItem().height(25)
            flex.addItem(completeButton).height(52).marginHorizontal(16).marginBottom(47)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    // MARK: - configure
    override func configureAttributes() {
        super.configureAttributes()
        titleLabel.text = "스택"
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

// MARK: - Data
/// 선택한 분야에 맞는 기술스택을 return
enum TechStack: String {
    case ios = "iOS"
    case android = "안드로이드"
    case frontend = "프론트엔드"
    case backend = "백엔드"
    case uiux = "UI/UX"
    case bibx = "BI/BX"
    case videomotion = "영상/모션"
    case pm = "PM"
    
    var techStacks: [String] {
        switch self {
        case .ios: return ["Swift", "Objective-C", "UIKit", "SwiftUI", "RxSwift", "Combine", "XCTest", "Tuist", "React Native", "Flutter"]
            
        case .android: return ["Kotlin", "Java", "Compose", "RxJava", "Coroutine", "Flutter", "React Native"]
            
        case .frontend: return ["Javascript", "TypeScript", "HTML", "CSS", "React", "React Native", "Vue", "Angular", "Svelte", "Jquery", "Backbone", "Pinia"]
            
        case .backend: return ["Java", "Javascript", "Python", "TypeScript", "C", "C++", "Kotlin", "Spring", "Springboot", "Nodejs", "Django", "Hibernate", "WebRTC", "MongoDB", "MySQL", "PostgreSQL", "Redis", "Maria DB", "H2"]
            
        case .uiux, .bibx, .videomotion: return designTechStacks
            
        case .pm: return ["Notion", "Jira", "Slack"]
        }
    }
    
    private var designTechStacks: [String] {
        return ["photoshop", "illustrator", "indesign", "adobe XD", "Figma", "Sketch", "Adobe flash"]
    }
}
