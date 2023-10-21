//
//  CompositionalLayoutConfiguration.swift
//  Bridge
//
//  Created by 엄지호 on 2023/10/17.
//

import UIKit

struct CompositionalLayoutConfiguration {
    let groupHeight: CGFloat
    let sectionContentInsets: NSDirectionalEdgeInsets
    let boundaryItemKinds: [BoundaryItemKind]  // 조건에 따라 헤더와 푸터를 유연하게 넣을 수 있음.
    
    private func configureItemLayout() -> NSCollectionLayoutItem {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )

        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 7.8, leading: 16, bottom: 0, trailing: 16)
        
        return item
    }
    
    private func configureGroupLayout() -> NSCollectionLayoutGroup {
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(groupHeight)
        )
        
        return NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [configureItemLayout()])
    }
    
    func configureSectionLayout() -> NSCollectionLayoutSection {
        let section = NSCollectionLayoutSection(group: configureGroupLayout())
        section.contentInsets = sectionContentInsets
        section.boundarySupplementaryItems = configureBoundaryItems()
        
        return section
    }
    
    func configureCompositionalLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout(section: configureSectionLayout())
    }
}

// MARK: - Header, Footer
extension CompositionalLayoutConfiguration {
    enum BoundaryItemKind {
        case header(height: CGFloat)
        case footer(topInset: CGFloat)
    }
    
    // 설정된 boundaryItemKinds 를 기반으로 헤더와 푸터를 설정
    private func configureBoundaryItems() -> [NSCollectionLayoutBoundarySupplementaryItem] {
        let boundaryItems = boundaryItemKinds.map { kind in
            switch kind {
            case .header(let height): return configureHeaderLayout(height: height)
            case .footer(let topInset): return configureFooterLayout(topInset: topInset)
            }
        }
        
        return boundaryItems
    }
    
    private func configureHeaderLayout(height: CGFloat) -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(height)
        )
        return NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
    }
    
    private func configureFooterLayout(topInset: CGFloat) -> NSCollectionLayoutBoundarySupplementaryItem {
        let footerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        )
        
        let footer = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: footerSize,
            elementKind: UICollectionView.elementKindSectionFooter,
            alignment: .bottom
        )
        footer.contentInsets = NSDirectionalEdgeInsets(top: topInset, leading: 0, bottom: 0, trailing: 0)
        
        return footer
    }
}
