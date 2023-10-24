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
                        
                        // 활성화된 window scene 찾음
                        var windowScene: UIWindowScene?
                        if let scene = UIApplication.shared
                            .connectedScenes
                            .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene { windowScene = scene }
                        
                        let bottomOfWindow = windowScene?.windows.first?.frame.height ?? 0  // 윈도우 하단 계산
                        let topOfKeyboard = bottomOfWindow - keyboardHeight                 // 키보드 상단 계산
                        
                        // 키보드 + input bar가 가리는 높이 계산
                        let coveredHeight = frameInWindow.maxY - (topOfKeyboard - 38)
                        
                        if coveredHeight > 0 {  // 키보드가 마지막 셀을 가리는 경우에만 collection view 올림
                            // safe area 만큼 더 올려야 함
                            let yPosition = coveredHeight + (collectionView.superview?.superview?.safeAreaInsets.bottom ?? 34)
                            collectionView.transform = CGAffineTransform(translationX: 0, y: -yPosition)
                        }
                    }
                }
            }
        }
    }
}
