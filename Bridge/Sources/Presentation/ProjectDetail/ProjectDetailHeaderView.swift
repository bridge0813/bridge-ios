//
//  ProjectDetailHeaderView.swift
//  Bridge
//
//  Created by 엄지호 on 2023/11/15.
//

import UIKit
import FlexLayout
import PinLayout
import RxSwift
import RxCocoa

/// 모집글에 대한 상세정보를 표시하는 헤더 뷰
final class ProjectDetailHeaderView: BaseCollectionReusableView {
    // MARK: - UI
    private let rootFlexContainer = UIView()
    
    private let dDayLabel = BridgeLinedChip()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = BridgeFont.headline1Long.font
        label.textColor = BridgeColor.gray01
        label.numberOfLines = 0
        
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = BridgeFont.body2Long.font
        label.textColor = BridgeColor.gray02
        label.numberOfLines = 0
        
        return label
    }()
    
    private let informationLabel: UILabel = {
        let label = UILabel()
        label.text = "기본정보"
        label.font = BridgeFont.subtitle2.font
        label.textColor = BridgeColor.gray01
        
        return label
    }()
    
    private let deadlineTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "모집 마감일"
        label.font = BridgeFont.body2.font
        label.textColor = BridgeColor.gray03
        
        return label
    }()
    
    private let deadlineLabel: UILabel = {
        let label = UILabel()
        label.font = BridgeFont.body2.font
        label.textColor = BridgeColor.gray01
        
        return label
    }()
    
    private let periodTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "프로젝트 기간"
        label.font = BridgeFont.body2.font
        label.textColor = BridgeColor.gray03
        
        return label
    }()
    
    private let periodLabel: UILabel = {
        let label = UILabel()
        label.font = BridgeFont.body2.font
        label.textColor = BridgeColor.gray01
        
        return label
    }()
    
    private let progressMethodTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "진행 방식"
        label.font = BridgeFont.body2.font
        label.textColor = BridgeColor.gray03
        
        return label
    }()
    
    private let progressMethodLabel: UILabel = {
        let label = UILabel()
        label.font = BridgeFont.body2.font
        label.textColor = BridgeColor.gray01
        
        return label
    }()
    
    private let progressStepTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "진행 단계"
        label.font = BridgeFont.body2.font
        label.textColor = BridgeColor.gray03
        
        return label
    }()
    
    private let progressStepLabel: UILabel = {
        let label = UILabel()
        label.font = BridgeFont.body2.font
        label.textColor = BridgeColor.gray01
        
        return label
    }()
    
    private let restrictionTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "지원자 제한"
        label.font = BridgeFont.body2.font
        label.textColor = BridgeColor.gray03
        
        return label
    }()
    
    private let restrictionLabel: UILabel = {
        let label = UILabel()
        label.font = BridgeFont.body2.font
        label.textColor = BridgeColor.gray01
        
        return label
    }()
    
    private let warningMessageBox = BridgeWarningMessageBox("")
    
    private let recruitNumberLabel: UILabel = {
        let label = UILabel()
        label.font = BridgeFont.subtitle2.font
        label.textColor = BridgeColor.gray01
        
        return label
    }()
    
    private let goToDetailButton: UIButton = {
        let button = UIButton()
        let buttonImage = UIImage(named: "chevron.right")?
            .resize(to: CGSize(width: 16, height: 16))
            .withRenderingMode(.alwaysTemplate)
        
        button.setImage(buttonImage, for: .normal)
        button.tintColor = BridgeColor.gray03
        button.contentHorizontalAlignment = .right
        
        return button
    }()
    
    // MARK: - Property
    var goToDetailButtonTapped: ControlEvent<Void> {
        return goToDetailButton.rx.tap
    }
    
    // MARK: - Layout
    override func configureLayouts() {
        addSubview(rootFlexContainer)
        rootFlexContainer.flex.define { flex in
            
            // 모집글의 제목과 소개(구분선을 기준으로 첫 번째 섹션)
            flex.addItem().backgroundColor(BridgeColor.gray10).paddingHorizontal(16).define { flex in
                flex.addItem(dDayLabel).marginTop(24)
                flex.addItem(titleLabel).height(60).marginTop(16).marginRight(49)
                flex.addItem(descriptionLabel).marginTop(8).marginBottom(32)
            }
            
            flex.addItem().backgroundColor(BridgeColor.gray09).height(8)
            
            // 모집글의 기본정보(구분선을 기준으로 두 번째 섹션)
            flex.addItem().backgroundColor(BridgeColor.gray10).paddingHorizontal(16).define { flex in
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
            
            flex.addItem().backgroundColor(BridgeColor.gray09).height(8)
            
            // 모집인원 및 이동버튼(구분선을 기준으로 세 번째 섹션)
            flex.addItem()
                .backgroundColor(BridgeColor.gray10)
                .direction(.row)
                .justifyContent(.spaceBetween)
                .height(70)
                .define { flex in
                    flex.addItem(recruitNumberLabel).height(32).marginTop(32).marginLeft(16)
                    flex.addItem(goToDetailButton).width(100).height(16).marginTop(38).marginRight(13)
                }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        rootFlexContainer.pin.all()
        rootFlexContainer.flex.layout()
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        rootFlexContainer.pin.all()
        rootFlexContainer.flex.layout(mode: .adjustHeight)

        return rootFlexContainer.frame.size
    }
}

// MARK: - Configuration
extension ProjectDetailHeaderView {
    func configureContents(with data: Project) {
        dDayLabel.text = "D-\(String(data.dDays))"
        titleLabel.configureTextWithLineHeight(text: data.title, lineHeight: 30)
        descriptionLabel.configureTextWithLineHeight(text: data.description, lineHeight: 20)
        
        deadlineLabel.text = data.deadline.toString(format: "yyyy.MM.dd")
        configurePeriodLabel(with: data)
        progressMethodLabel.text = data.progressMethod
        progressStepLabel.text = data.progressStep
        
        let restrictionText = data.applicantRestrictions.joined(separator: ", ")
        restrictionLabel.text = restrictionText
        
        if restrictionText == "제한없음" {
            warningMessageBox.flex.isIncludedInLayout(false).markDirty()
            warningMessageBox.isHidden = true  // 이미지가 남아있는 에러에 대응
            
        } else {
            warningMessageBox.updateTitle("이 프로젝트는 \(restrictionText)의 지원이 제한되어 있습니다.")
        }
        
        let totalNumber = data.memberRequirements.reduce(0) { partialResult, requirement in
            return partialResult + requirement.recruitNumber
        }
        recruitNumberLabel.highlightTextColor(text: "\(totalNumber)명 모집중", highlightText: "\(totalNumber)명")
        
        dDayLabel.flex.width(dDayLabel.intrinsicContentSize.width).height(22)
        dDayLabel.flex.markDirty()
        setNeedsLayout()
    }
    
    func configurePeriodLabel(with data: Project) {
        let startDateString = data.startDate?.toString(format: "yyyy.MM.dd") ?? "미정"
        let endDateString = data.endDate?.toString(format: "yyyy.MM.dd") ?? "미정"
        
        switch (data.startDate, data.endDate) {
            
        case (let startDate?, let endDate?):  // 둘 다 Date일 경우
            let monthsBetweenDates = Calendar.current.dateComponents([.month], from: startDate, to: endDate).month ?? 0
            
            periodLabel.highlightTextColor(
                text: "\(startDateString)~\(endDateString) (\(monthsBetweenDates)개월)",
                highlightText: "(\(monthsBetweenDates)개월)"
            )
            
        case (nil, nil):  // 둘 다 nil 일 경우
            periodLabel.text = "미정"
            
        default:
            periodLabel.text = "\(startDateString)~\(endDateString)"
        }
    }
}
