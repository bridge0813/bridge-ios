//
//  BridgeSetFieldView.swift
//  Bridge
//
//  Created by 정호윤 on 10/5/23.
//

import UIKit
import RxSwift

final class BridgeSetFieldView: BaseView {
    // MARK: - UI
    private let rootFlexContainer = UIView()
    
    private let developerLabel: UILabel = {
        let label = UILabel()
        label.text = "개발자"
        label.font = BridgeFont.subtitle2.font
        label.textColor = BridgeColor.gray01
        return label
    }()
    
    private let iosButton = BridgeFieldTagButton("iOS")
    private let androidButton = BridgeFieldTagButton("안드로이드")
    private let frontendButton = BridgeFieldTagButton("프론트엔드")
    private let backendButton = BridgeFieldTagButton("백엔드")
    
    private let designerLabel: UILabel = {
        let label = UILabel()
        label.text = "디자이너"
        label.font = BridgeFont.subtitle2.font
        label.textColor = BridgeColor.gray01
        return label
    }()
    
    private let uiuxButton = BridgeFieldTagButton("UI/UX")
    private let bibxButton = BridgeFieldTagButton("BI/BX")
    private let videomotionButton = BridgeFieldTagButton("영상/모션")
    
    private let pmLabel: UILabel = {
        let label = UILabel()
        label.text = "기획자"
        label.font = BridgeFont.subtitle2.font
        label.textColor = BridgeColor.gray01
        return label
    }()
    
    private let pmButton = BridgeFieldTagButton("PM")
    
    // MARK: - Configuration
    override func configureLayouts() {
        addSubview(rootFlexContainer)
        
        let labelMargin: CGFloat = 14           // 레이블과 다른 컴포넌트 간 마진
        let sectionMargin: CGFloat = 32         // 섹션 간 마진
        let containerSize: CGFloat = 200        // 관심분야 버튼 컨테이너 크기
        let buttonMargin: CGFloat = 12          // 관심분야 버튼 간 간격
        
        rootFlexContainer.flex.define { flex in
            // 개발자 섹션
            flex.addItem().define { flex in
                flex.addItem(developerLabel).marginBottom(labelMargin)
                
                flex.addItem()
                    .direction(.row)
                    .alignItems(.start)
                    .wrap(.wrap)
                    .width(containerSize)
                    .marginBottom(sectionMargin)
                    .define { flex in
                        flex.addItem(iosButton).marginRight(buttonMargin).marginBottom(buttonMargin)
                        flex.addItem(androidButton)
                        flex.addItem(frontendButton).marginRight(buttonMargin).marginBottom(buttonMargin)
                        flex.addItem(backendButton)
                    }
            }
            
            // 디자이너 섹션
            flex.addItem().define { flex in
                flex.addItem(designerLabel).marginBottom(labelMargin)
                
                flex.addItem()
                    .direction(.row)
                    .alignItems(.start)
                    .wrap(.wrap)
                    .width(containerSize)
                    .marginBottom(sectionMargin)
                    .define { flex in
                        flex.addItem(uiuxButton).marginRight(buttonMargin).marginBottom(buttonMargin)
                        flex.addItem(bibxButton)
                        flex.addItem(videomotionButton).marginBottom(buttonMargin)
                    }
            }
            
            // 기획자 섹션
            flex.addItem().define { flex in
                flex.addItem(pmLabel).marginBottom(labelMargin)
                
                flex.addItem()
                    .direction(.row)
                    .alignItems(.start)
                    .wrap(.wrap)
                    .width(containerSize)
                    .define { flex in
                        flex.addItem(pmButton)
                    }
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        rootFlexContainer.pin.all()
        rootFlexContainer.flex.layout()
    }
}

// MARK: - Button tap observable
extension BridgeSetFieldView {
    enum FieldTagButtonType: String {
        case ios = "IOS"
        case android = "ANDROID"
        case frontend = "FRONTEND"
        case backend = "BACKEND"
        case uiux = "UIUX"
        case bibx = "BIBX"
        case videomotion = "VIDEOMOTION"
        case pm = "PM"
    }
    
    var fieldTagButtonTapped: Observable<String> {
        Observable.merge(
            iosButton.rx.tap.map { FieldTagButtonType.ios.rawValue },
            androidButton.rx.tap.map { FieldTagButtonType.android.rawValue },
            frontendButton.rx.tap.map { FieldTagButtonType.frontend.rawValue },
            backendButton.rx.tap.map { FieldTagButtonType.backend.rawValue },
            uiuxButton.rx.tap.map { FieldTagButtonType.uiux.rawValue },
            bibxButton.rx.tap.map { FieldTagButtonType.bibx.rawValue },
            videomotionButton.rx.tap.map { FieldTagButtonType.videomotion.rawValue },
            pmButton.rx.tap.map { FieldTagButtonType.pm.rawValue }
        )
    }
}

extension BridgeSetFieldView {
    /// 버튼의 선택 상태를 업데이트하는 메서드(중복 선택 불가)
    func updateButtonStateToSingleSelection(_ selectedField: String) {
        let allButtons = [iosButton, androidButton, frontendButton, backendButton, uiuxButton, bibxButton, videomotionButton, pmButton]
        allButtons.forEach { $0.isSelected = false }
        
        if let buttonType = FieldTagButtonType(rawValue: selectedField) {
            switch buttonType {
            case .ios:
                iosButton.isSelected = true
                
            case .android:
                androidButton.isSelected = true
                
            case .frontend:
                frontendButton.isSelected = true
                
            case .backend:
                backendButton.isSelected = true
                
            case .uiux:
                uiuxButton.isSelected = true
                
            case .bibx:
                bibxButton.isSelected = true
                
            case .videomotion:
                videomotionButton.isSelected = true
                
            case .pm:
                pmButton.isSelected = true
            }
        }
    }
    
    /// 버튼의 선택 상태를 업데이트하는 메서드(중복 선택 가능)
    func updateButtonStateToMultipleSelections(_ selectedFields: [String]) {
        selectedFields.forEach { field in
            if let buttonType = FieldTagButtonType(rawValue: field) {
                switch buttonType {
                case .ios:
                    iosButton.isSelected = true
                    
                case .android:
                    androidButton.isSelected = true
                    
                case .frontend:
                    frontendButton.isSelected = true
                    
                case .backend:
                    backendButton.isSelected = true
                    
                case .uiux:
                    uiuxButton.isSelected = true
                    
                case .bibx:
                    bibxButton.isSelected = true
                    
                case .videomotion:
                    videomotionButton.isSelected = true
                    
                case .pm:
                    pmButton.isSelected = true
                }
            }
        }
    }
}
