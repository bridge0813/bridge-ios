//
//  RecruitmentFieldInfoView.swift
//  Bridge
//
//  Created by 엄지호 on 2023/11/10.
//

import UIKit
import FlexLayout
import PinLayout
import RxSwift
import RxCocoa

/// 상세 모집글의 모집중인 분야와 인원 수를 나타내는 뷰
final class RecruitmentFieldInfoView: BaseView {
    // MARK: - UI
    private let rootFlexContainer: UIView = {
        let view = UIView()
        view.backgroundColor = BridgeColor.gray10
        
        return view
    }()
    
    private let recruitLabel: UILabel = {
        let label = UILabel()
        label.font = BridgeFont.subtitle2.font
        label.textColor = BridgeColor.gray01
        
        return label
    }()
    
    private let goToDetailButton: UIButton = {
        let button = UIButton()
        let buttonImage = UIImage(named: "chevron.right")?
            .resize(to: CGSize(width: 16, height: 16))
            .withRenderingMode(.alwaysTemplate)
        
        button.setImage(buttonImage, for: .normal)
        button.tintColor = BridgeColor.gray03
        button.contentHorizontalAlignment = .right
        
        return button
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: configureLayout())
        collectionView.register(RecruitFieldCell.self)
        
        return collectionView
    }()
    
    // MARK: - Property
    var goToDetailButtonTapped: ControlEvent<Void> {
        return goToDetailButton.rx.tap
    }
    
    // MARK: - Configuration
    func configureContents(with requirements: [MemberRequirement]) {
        // 모집중인 총 인원 구하기
        let totalNumber = requirements.reduce(0) { partialResult, requirement in
            return partialResult + requirement.recruitNumber
        }
        
        let labelText = "\(totalNumber)명 모집중"
        let attributedString = NSMutableAttributedString(string: labelText)

        if let rangeOfNumber = labelText.range(of: "\(totalNumber)명") {
            let nsRange = NSRange(rangeOfNumber, in: labelText)
            attributedString.addAttribute(.foregroundColor, value: BridgeColor.primary1, range: nsRange)
        }

        recruitLabel.attributedText = attributedString
        
        // Data source
        Observable.of(requirements)
            .bind(
                to: collectionView.rx.items(
                    cellIdentifier: RecruitFieldCell.reuseIdentifier,
                    cellType: RecruitFieldCell.self
                )
            ) { _, requirement, cell in
                cell.configureCell(with: requirement)
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - Layout
    override func configureLayouts() {
        addSubview(rootFlexContainer)
        rootFlexContainer.flex.define { flex in
            flex.addItem()
                .direction(.row)
                .justifyContent(.spaceBetween)
                .alignItems(.center)
                .height(24)
                .marginTop(32)
                .define { flex in
                flex.addItem(recruitLabel).marginLeft(16)
                flex.addItem(goToDetailButton).grow(1).marginRight(13)
                }
            
            flex.addItem(collectionView).height(127).marginTop(14)
            
            flex.addItem().height(20)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        rootFlexContainer.pin.all()
        rootFlexContainer.flex.layout()
    }
}

// MARK: - CompositionalLayout
extension RecruitmentFieldInfoView {
    private func configureLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )

        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(190),
            heightDimension: .absolute(127)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
        section.orthogonalScrollingBehavior = .continuous
        
        return UICollectionViewCompositionalLayout(section: section)
    }
}
