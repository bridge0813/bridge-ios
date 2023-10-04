//
//  SetFieldViewController.swift
//  Bridge
//
//  Created by 정호윤 on 2023/09/12.
//

import UIKit
import PinLayout
import FlexLayout
import RxCocoa
import RxSwift

final class SetFieldViewController: BaseViewController {
    // MARK: - UI
    private let rootFlexViewContainer = UIView()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "당신의 관심 프로젝트는\n어떤 분야인가요?"
        label.font = BridgeFont.headline1Long.font
        label.textColor = BridgeColor.gray1
        label.numberOfLines = 0
        return label
    }()
    
    private let tipMessageBox = BridgeTipMessageBox("관심분야 설정하고 맞춤 홈화면 받아보세요!")
    
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
    
    // MARK: - Init
    private let viewModel: SetFieldViewModel
    
    init(viewModel: SetFieldViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Configuration
    override func configureAttributes() {
        navigationItem.title = "관심분야"
        navigationItem.hidesBackButton = true
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false  // 밀어서 뒤로가기 제한
    }
    
    // MARK: - description label line height, 유지보수성, 동적으로? 다듬기
    override func configureLayouts() {
        view.addSubview(rootFlexViewContainer)
        
        rootFlexViewContainer.flex.paddingHorizontal(16).define { flex in
            flex.addItem(descriptionLabel).marginTop(24)
            flex.addItem(tipMessageBox).marginTop(14).marginBottom(40)
            
            // 개발자 섹션
            flex.addItem().define { flex in
                flex.addItem(developerLabel).marginBottom(14)
                
                flex.addItem()
                    .direction(.row)
                    .alignItems(.start)
                    .wrap(.wrap)
                    .width(190)
                    .marginBottom(24)
                    .define { flex in
                        flex.addItem(iosButton).marginRight(12).marginBottom(12)
                        flex.addItem(androidButton)
                        flex.addItem(frontendButton).marginRight(12).marginBottom(12)
                        flex.addItem(backendButton)
                    }
            }
            
            // 디자이너 섹션
            flex.addItem().define { flex in
                flex.addItem(designerLabel).marginBottom(14)
                
                flex.addItem()
                    .direction(.row)
                    .alignItems(.start)
                    .wrap(.wrap)
                    .width(165)
                    .marginBottom(24)
                    .define { flex in
                        flex.addItem(uiuxButton).marginRight(12).marginBottom(12)
                        flex.addItem(bibxButton)
                        flex.addItem(videomotionButton)
                    }
            }
            
            // PM 섹션
            flex.addItem().define { flex in
                flex.addItem(pmLabel).marginBottom(14)
                
                flex.addItem()
                    .direction(.row)
                    .alignItems(.start)
                    .wrap(.wrap)
                    .define { flex in
                        flex.addItem(pmButton)
                    }
            }
            
            flex.addItem().grow(1)  // spacer
            
            flex.addItem(completeButton).height(52).marginBottom(24)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        rootFlexViewContainer.pin.all(view.pin.safeArea)
        rootFlexViewContainer.flex.layout()
    }
    
    override func bind() {
        let input = SetFieldViewModel.Input(
            completeButtonTapped: completeButton.rx.tap.asObservable()
        )
        
        _ = viewModel.transform(input: input)
    }
}
