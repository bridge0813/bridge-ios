//
//  MenuBar.swift
//  Bridge
//
//  Created by 엄지호 on 2023/11/13.
//

import UIKit
import FlexLayout
import PinLayout
import RxSwift
import RxCocoa

/// 프로젝트 상세의 하단 메뉴 바
final class ProjectDetailMenuBar: BaseView {
    // MARK: - UI
    private let rootFlexContainer: UIView = {
        let view = UIView()
        view.backgroundColor = BridgeColor.gray10
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.04
        view.layer.shadowOffset = CGSize(width: 0, height: -6)
        view.layer.shadowRadius = 10.0
        
        return view
    }()
    
    private let bookmarkButton = BridgeBookmarkButton()
    
    private let applyButton: BridgeButton = {
        let button = BridgeButton(
            title: "지원하기",
            font: BridgeFont.button1.font,
            backgroundColor: BridgeColor.gray04
        )
        button.isEnabled = true
        
        return button
    }()
    
    // MARK: - Property
    /// 북마크 버튼의 북마크 표시 여부
    var isBookmarked = false {
        didSet {
            bookmarkButton.isBookmarked = isBookmarked
        }
    }
    
    var bookmarkButtonTapped: Observable<Bool> {
        return bookmarkButton.rx.tap
            .withUnretained(self)
            .map { owner, _ in
                return owner.bookmarkButton.isSelected
            }
    }
    
    var applyButtonTapped: Observable<Void> {
        return applyButton.rx.tap.asObservable()
    }
    
    // MARK: - Layout
    override func configureLayouts() {
        addSubview(rootFlexContainer)
        rootFlexContainer.flex.direction(.row).height(102).paddingHorizontal(16).define { flex in
            flex.addItem(bookmarkButton).width(54).height(52).marginTop(15)
            flex.addItem(applyButton).grow(1).height(52).marginTop(15).marginLeft(12)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        rootFlexContainer.pin.all()
        rootFlexContainer.flex.layout()
        
        let shadowPath = UIBezierPath(rect: rootFlexContainer.bounds)
        rootFlexContainer.layer.shadowPath = shadowPath.cgPath
    }
}
