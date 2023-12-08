////
////  ProjectManagementPopUpView.swift
////  Bridge
////
////  Created by 엄지호 on 2023/11/15.
////
//
//import UIKit
//import FlexLayout
//import PinLayout
//import RxSwift
//import RxCocoa
//
///// 수정, 삭제, 마감 등 모집글을 관리하는 메뉴 팝업 뷰
//final class ProjectManagementMenuPopUpView: BridgeBasePopUpView {
//    // MARK: - UI
//    private let editButton: UIButton = {
//        let button = UIButton()
//        button.setTitle("수정하기", for: .normal)
//        button.setTitleColor(BridgeColor.gray02, for: .normal)
//        button.titleLabel?.font = BridgeFont.subtitle3.font
//        
//        return button
//    }()
//    
//    private let closeButton: UIButton = {
//        let button = UIButton()
//        button.setTitle("마감하기", for: .normal)
//        button.setTitleColor(BridgeColor.gray02, for: .normal)
//        button.titleLabel?.font = BridgeFont.subtitle3.font
//        
//        return button
//    }()
//    
//    private let deleteButton: UIButton = {
//        let button = UIButton()
//        button.setTitle("삭제하기", for: .normal)
//        button.setTitleColor(BridgeColor.gray02, for: .normal)
//        button.titleLabel?.font = BridgeFont.subtitle3.font
//        
//        return button
//    }()
//    
//    // MARK: - Property
//    override var containerHeight: CGFloat { 206 }
//    override var dismissYPosition: CGFloat { 130 }
//    
//    var menuTapped: Observable<String> {
//        return Observable.merge(
//            editButton.rx.tap
//                .withUnretained(self)
//                .map { owner, _ in
//                    owner.hide()
//                    return "수정"
//                },
//            closeButton.rx.tap
//                .withUnretained(self)
//                .map { owner, _ in
//                    owner.hide()
//                    return "마감"
//                },
//            deleteButton.rx.tap
//                .withUnretained(self)
//                .map { owner, _ in
//                    owner.hide()
//                    return "삭제"
//                }
//        )
//    }
//    
//    // MARK: - Configuration
//    override func configureAttributes() {
//        super.configureAttributes()
//    }
//    
//    // MARK: - Layout
//    override func configureLayouts() {
//        super.configureLayouts()
//        
//        rootFlexContainer.flex.alignItems(.center).paddingHorizontal(18).define { flex in
//            flex.addItem(dragHandleBar).marginTop(8)
//            
//            flex.addItem(editButton).width(56).height(19).marginTop(15)
//            flex.addItem().backgroundColor(BridgeColor.gray09).width(100%).height(1).marginTop(16)
//            
//            flex.addItem(closeButton).width(56).height(19).marginTop(16)
//            flex.addItem().backgroundColor(BridgeColor.gray09).width(100%).height(1).marginTop(16)
//            
//            flex.addItem(deleteButton).width(56).height(19).marginTop(16)
//        }
//    }
//    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//    }
//}
