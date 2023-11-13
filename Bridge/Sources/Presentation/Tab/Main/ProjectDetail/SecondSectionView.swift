//
//  SecondSectionView.swift
//  Bridge
//
//  Created by 엄지호 on 2023/11/10.
//

import UIKit
import FlexLayout
import PinLayout

/// 상세 모집글의 두 번째 섹션(기본정보)
final class SecondSectionView: BaseView {
    // MARK: - UI
    private let rootFlexContainer: UIView = {
        let view = UIView()
        view.backgroundColor = BridgeColor.gray10
        
        return view
    }()
    
    private let informationLabel: UILabel = {
        let label = UILabel()
        label.text = "기본정보"
        label.font = BridgeFont.subtitle2.font
        label.textColor = BridgeColor.gray1
        
        return label
    }()
    
    private let deadlineTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "모집 마감일"
        label.font = BridgeFont.body2.font
        label.textColor = BridgeColor.gray3
        
        return label
    }()
    
    private let deadlineLabel: UILabel = {
        let label = UILabel()
        label.text = "2023.09.05"
        label.font = BridgeFont.body2.font
        label.textColor = BridgeColor.gray1
        
        return label
    }()
    
    private let periodTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "프로젝트 기간"
        label.font = BridgeFont.body2.font
        label.textColor = BridgeColor.gray3
        
        return label
    }()
    
    private let periodLabel: UILabel = {
        let label = UILabel()
        label.text = "2023.09.11~2023.12.14(4개월)"
        label.font = BridgeFont.body2.font
        label.textColor = BridgeColor.gray1
        
        return label
    }()
    
    private let progressMethodTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "진행 방식"
        label.font = BridgeFont.body2.font
        label.textColor = BridgeColor.gray3
        
        return label
    }()
    
    private let progressMethodLabel: UILabel = {
        let label = UILabel()
        label.text = "블랜디드"
        label.font = BridgeFont.body2.font
        label.textColor = BridgeColor.gray1
        
        return label
    }()
    
    private let progressStepTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "진행 단계"
        label.font = BridgeFont.body2.font
        label.textColor = BridgeColor.gray3
        
        return label
    }()
    
    private let progressStepLabel: UILabel = {
        let label = UILabel()
        label.text = "기획 중이에요"
        label.font = BridgeFont.body2.font
        label.textColor = BridgeColor.gray1
        
        return label
    }()
    
    private let restrictionTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "지원자 제한"
        label.font = BridgeFont.body2.font
        label.textColor = BridgeColor.gray3
        
        return label
    }()
    
    private let restrictionLabel: UILabel = {
        let label = UILabel()
        label.text = "학생, 취준생"
        label.font = BridgeFont.body2.font
        label.textColor = BridgeColor.gray1
        
        return label
    }()
    
    private let warningMessageBox = BridgeWarningMessageBox("이 프로젝트는 학생, 취준생의 지원이 제한되어 있습니다.")
    
    // MARK: - Layout
    override func configureLayouts() {
        addSubview(rootFlexContainer)
        rootFlexContainer.flex.paddingHorizontal(16).define { flex in
            flex.addItem(informationLabel).width(56).height(24).marginTop(32)
            
            flex.addItem().direction(.row).height(18).marginTop(14).define { flex in
                flex.addItem(deadlineTitleLabel).width(64)
                flex.addItem(deadlineLabel).marginLeft(43)
            }
            
            flex.addItem().direction(.row).height(18).marginTop(12).define { flex in
                flex.addItem(periodTitleLabel).width(77)
                flex.addItem(periodLabel).marginLeft(30)
            }
            
            flex.addItem().direction(.row).height(18).marginTop(12).define { flex in
                flex.addItem(progressMethodTitleLabel).width(52)
                flex.addItem(progressMethodLabel).marginLeft(55)
            }
            
            flex.addItem().direction(.row).height(18).marginTop(12).define { flex in
                flex.addItem(progressStepTitleLabel).width(52)
                flex.addItem(progressStepLabel).marginLeft(55)
            }
            
            flex.addItem().direction(.row).height(18).marginTop(12).define { flex in
                flex.addItem(restrictionTitleLabel).width(64)
                flex.addItem(restrictionLabel).marginLeft(43)
            }
            
            flex.addItem(warningMessageBox).height(38).marginTop(16)
            
            flex.addItem().height(32)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        rootFlexContainer.pin.all()
        rootFlexContainer.flex.layout()
    }
}
