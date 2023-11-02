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
final class AddTechTagPopUpView: BaseView {
    // MARK: - UI
    private let rootFlexContainer: UIView = {
        let view = UIView()
        view.backgroundColor = BridgeColor.gray10
        view.clipsToBounds = true
        view.layer.cornerRadius = 12
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        return view
    }()
    
    private let dragHandleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "draghandle")
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private let stackLabel: UILabel = {
        let label = UILabel()
        label.text = "스택"
        label.font = BridgeFont.subtitle1.font
        label.textColor = BridgeColor.gray1
        
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: configureLayout())
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(TechTagCell.self)
        
        return collectionView
    }()
    
    private let completeButton: BridgeButton = {
        let button = BridgeButton(
            title: "완료",
            font: BridgeFont.button1.font,
            backgroundColor: BridgeColor.gray4
        )
        button.isEnabled = false
        
        return button
    }()
    
    // MARK: - Properties
    /// 선택된 분야를 전달받으면
    /// willSet - 데이터소스를 결정 할 타입을 저장
    /// didSet - 데이터소스를 바인딩하여 CollectionView Cell을 구현(CollectionViewDataSource 역할)
    var field = String() {
        willSet {
            fieldType = FieldTagType(rawValue: newValue) ?? .ios
        }
        
        didSet {
            Observable.of(fieldType.dataSource)
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
    
    private var fieldType: FieldTagType = .ios  // 선택된 분야에 맞게 데이터소스를 결정
    private var selectedTags: [String] = []     // 선택한 기술태그를 저장
    
    var completeButtonTapped: Observable<[String]> {
        return completeButton.rx.tap
            .withUnretained(self)
            .map { owner, _ in
                owner.hide()
                return owner.selectedTags
            }
            .distinctUntilChanged()
    }
    
    // MARK: - Layout
    override func configureLayouts() {
        addSubview(rootFlexContainer)
        
        rootFlexContainer.flex.define { flex in
            flex.addItem(dragHandleImageView).alignSelf(.center).width(25).height(7).marginTop(10)
            
            flex.addItem(stackLabel).width(32).height(22).marginTop(30).marginLeft(16)
            
            flex.addItem().backgroundColor(BridgeColor.gray8).height(1).marginTop(7)
            
            flex.addItem(collectionView).grow(1).marginTop(30).marginHorizontal(16)
            
            flex.addItem().height(25)
            flex.addItem(completeButton).height(52).marginHorizontal(16).marginBottom(47)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        rootFlexContainer.pin.below(of: self).width(100%).height(576)
        rootFlexContainer.flex.layout()
    }
    
    // MARK: - configure
    override func configureAttributes() {
        backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        rootFlexContainer.addGestureRecognizer(panGesture)
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


// MARK: - PanGesture
extension AddTechTagPopUpView {
    @objc
    private func handlePanGesture(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: rootFlexContainer)
        let velocity = sender.velocity(in: rootFlexContainer)
        
        let currentTranslationY: CGFloat = -576  // 초기 컨테이너의 오프셋
        let calculatedTranslationY = currentTranslationY + translation.y  // 초기 오프셋을 고려한 결과값
        
        switch sender.state {
        case .changed:
            // 아래로 드래그하거나 최대 높이 이내에서만 transform을 적용
            if calculatedTranslationY > currentTranslationY && calculatedTranslationY <= 0 {
                rootFlexContainer.transform = CGAffineTransform(translationX: 0, y: calculatedTranslationY)
            }
            
        case .ended:
            if velocity.y > 1500 || calculatedTranslationY > -300 {
                hide()
                
            } else {  // 원상복구
                UIView.animate(withDuration: 0.2) {
                    self.rootFlexContainer.transform = CGAffineTransform(translationX: 0, y: currentTranslationY)
                }
            }
            
        default:
            break
        }
    }
}

// MARK: - Show & Hide
extension AddTechTagPopUpView {
    func show() {
        setLayout()
        
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            guard let self else { return }
            self.rootFlexContainer.transform = CGAffineTransform(translationX: 0, y: -576)
        })
    }

    private func setLayout() {
        let window = UIWindow.visibleWindow() ?? UIWindow()
        window.addSubview(self)
        window.bringSubviewToFront(self)
        
        pin.all()
    }
    
    private func hide() {
        UIView.animate(
            withDuration: 0.2,
            animations: { [weak self] in
                guard let self else { return }
                self.rootFlexContainer.transform = .identity
                
            }, completion: { [weak self] _ in
                guard let self else { return }
                self.removeFromSuperview()
            }
        )
    }
}

// MARK: - Data
extension AddTechTagPopUpView {
    /// 선택한 분야를 입력받으면, 맵핑하여 데이터소스를 사용하기 위함.
    enum FieldTagType: String {
        case ios = "iOS"
        case android = "안드로이드"
        case frontend = "프론트엔드"
        case backend = "백엔드"
        case uiux = "UI/UX"
        case bibx = "BI/BX"
        case videomotion = "영상/모션"
        case pm = "PM"
        
        var dataSource: [String] {
            switch self {
            case .ios: return ["Swift", "Objective-C", "UIKit", "SwiftUI", "RxSwift", "Combine", "XCTest", "Tuist", "React Native", "Flutter"]
                
            case .android: return ["Kotlin", "Java", "Compose", "RxJava", "Coroutine", "Flutter", "React Native"]
                
            case .frontend: return ["Javascript", "TypeScript", "HTML", "CSS", "React", "React Native", "Vue", "Angular", "Svelte", "Jquery", "Backbone", "Pinia"]
                
            case .backend: return ["Java", "Javascript", "Python", "TypeScript", "C", "C++", "Kotlin", "Spring", "Springboot", "Nodejs", "Django", "Hibernate", "WebRTC", "MongoDB", "MySQL", "PostgreSQL", "Redis", "Maria DB", "H2"]
                
            case .uiux: return ["photoshop", "illustrator", "indesign", "adobe XD", "Figma", "Sketch", "Adobe flash"]
                
            case .bibx: return ["photoshop", "illustrator", "indesign", "adobe XD", "Figma", "Sketch", "Adobe flash"]
                
            case .videomotion: return ["photoshop", "illustrator", "indesign", "adobe XD", "Figma", "Sketch", "Adobe flash"]
                
            case .pm: return ["Notion", "Jira", "Slack"]
            }
        }
    }
}
