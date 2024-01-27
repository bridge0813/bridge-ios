//
//  AddedTechTagView.swift
//  Bridge
//
//  Created by 엄지호 on 2023/10/25.
//

import UIKit
import FlexLayout
import PinLayout
import RxSwift
import RxCocoa

/// 팀원에 대한 스택을 추가하면, 추가된 스택에 맞게 tag로 보여주는  뷰
final class AddedTechTagView: BaseView {
    // MARK: - UI
    private let rootFlexContainer = UIView()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: configureLayout())
        collectionView.backgroundColor = BridgeColor.gray09
        collectionView.layer.cornerRadius = 4
        collectionView.clipsToBounds = true
        collectionView.isScrollEnabled = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(TechTagCell.self)
        collectionView.dataSource = self
        
        return collectionView
    }()
    
    // MARK: - Property
    var tagNames: [String] = [] {
        didSet {
            collectionView.backgroundColor = .clear
            collectionView.reloadData()
            collectionView.layoutIfNeeded()
            
            let collectionViewHeight = collectionView.contentSize.height
            collectionView.flex.height(collectionViewHeight)
            collectionView.flex.markDirty()
        }
    }
    
    // MARK: - Layout
    override func configureLayouts() {
        addSubview(rootFlexContainer)
        rootFlexContainer.flex.define { flex in
            flex.addItem(collectionView).height(52)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        rootFlexContainer.pin.all()
        rootFlexContainer.flex.layout()
    }
}

// MARK: - CompositionalLayout
extension AddedTechTagView {
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

extension AddedTechTagView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        tagNames.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(TechTagCell.self, for: indexPath) else {
            return UICollectionViewCell()
        }

        cell.configure(tagName: tagNames[indexPath.row], changesSelectionAsPrimaryAction: false)

        return cell
    }
}
