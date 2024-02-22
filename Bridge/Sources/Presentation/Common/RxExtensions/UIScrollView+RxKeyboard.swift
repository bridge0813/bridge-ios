//
//  UIScrollView+RxKeyboard.swift
//  Bridge
//
//  Created by 정호윤 on 10/24/23.
//

import UIKit
import RxSwift

extension Reactive where Base: UICollectionView {
    var yPosition: Binder<CGFloat> {
        Binder(base) { collectionView, keyboardHeight in
            UIView.animate(withDuration: 0.3) {
                if keyboardHeight == 0 {
                    collectionView.transform = CGAffineTransform.identity
                } else {
                    // 마지막 섹션과 마지막 아이템의 index path를 찾음
                    let lastSection = collectionView.numberOfSections - 1
                    let lastItem = collectionView.numberOfItems(inSection: lastSection) - 1
                    let lastIndexPath = IndexPath(item: lastItem, section: lastSection)
                    
                    // collection view 가장 아래로 스크롤
                    collectionView.scrollToItem(at: lastIndexPath, at: .top, animated: false)
                    
                    // 마지막 인덱스의 아이템에 대한 레이아웃 속성을 가져옴
                    if let attributes = collectionView.layoutAttributesForItem(at: lastIndexPath) {
                        // 아이템의 frame을 window 좌표계로 변환
                        let frameInWindow = collectionView.convert(attributes.frame, to: nil)
                        
                        // 활성화된 window 찾음
                        let window = UIWindow.visibleWindow() ?? UIWindow()
                        let windowMaxY = window.bounds.maxY  // 윈도우 하단 계산
                        
                        // 키보드 + inputBar 상단
                        let topOfInputBar = windowMaxY - (keyboardHeight + 60)
                        
                        // 가리는 높이 계산
                        let coveredHeight = frameInWindow.maxY - topOfInputBar
                        
                        // 키보드가 마지막 셀을 가리는 경우에만 collection view 올림
                        if coveredHeight > 0 {
                            // 컬렉션 뷰의 Bottom Content Inset 만큼 더 올려주기
                            let yPosition = coveredHeight + 16
                            collectionView.transform = CGAffineTransform(translationX: 0, y: -yPosition)
                        }
                    }
                }
            }
        }
    }
}
