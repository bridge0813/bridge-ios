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
    let headerHeight: CGFloat?
    
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
    
    func configureSectionLayout() -> NSCollectionLayoutSection {
        let section = NSCollectionLayoutSection(group: configureGroupLayout())
        section.contentInsets = sectionContentInsets
        
        if let headerHeight {
            section.boundarySupplementaryItems = [configureHeaderLayout(height: headerHeight)]
        }
        
        return section
    }
    
    func configureCompositionalLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout(section: configureSectionLayout())
    }
}
