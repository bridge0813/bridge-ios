//
//  BridgeSetFieldView.swift
//  Bridge
//
//  Created by 정호윤 on 10/5/23.
//

import UIKit

final class BridgeSetFieldView: BaseView {
    // MARK: - UI
    private let rootFlexContainer = UIView()
    
    private let developerLabel: UILabel = {
        let label = UILabel()
        label.text = "개발자"
        label.font = BridgeFont.subtitle2.font
        label.textColor = BridgeColor.gray1
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
        label.textColor = BridgeColor.gray1
        return label
    }()
    
    private let uiuxButton = BridgeFieldTagButton("UI/UX")
    private let bibxButton = BridgeFieldTagButton("BI/BX")
    private let videomotionButton = BridgeFieldTagButton("영상/모션")
    
    private let pmLabel: UILabel = {
        let label = UILabel()
        label.text = "기획자"
        label.font = BridgeFont.subtitle2.font
        label.textColor = BridgeColor.gray1
        return label
    }()
    
    private let pmButton = BridgeFieldTagButton("PM")
    
    private let completeButton = BridgeButton(
        "관심분야 설정하기",
        titleFont: BridgeFont.button1.font,
        backgroundColor: BridgeColor.primary1
    )
    
    // MARK: - Configuration
    override func configureLayouts() {
        addSubview(rootFlexContainer)
        
        let labelMargin: CGFloat = 14           // 레이블과 다른 컴포넌트 간 마진
        let sectionMargin: CGFloat = 24         // 섹션 간 마진
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
                        flex.addItem(videomotionButton)
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
