//
//  BasicInfoView.swift
//  Bridge
//
//  Created by 엄지호 on 2023/11/10.
//

import UIKit
import FlexLayout
import PinLayout

/// 상세 모집글의 기본 정보를 나타내는 뷰
final class BasicInfoView: BaseView {
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
    
    func configureContents(with data: Project) {
        if let startDate = data.startDate, let endDate = data.endDate {  // 둘 다 Date일 경우
            let startDateString = startDate.toString(format: "yyyy.MM.dd")
            let endDateString = endDate.toString(format: "yyyy.MM.dd")
            let monthsBetweenDates = Calendar.current.dateComponents([.month], from: startDate, to: endDate).month ?? 0
            
            let labelText = "\(startDateString)~\(endDateString) (\(monthsBetweenDates)개월)"
            let attributedString = NSMutableAttributedString(string: labelText)

            if let rangeOfNumber = labelText.range(of: "(\(monthsBetweenDates)개월)") {
                let nsRange = NSRange(rangeOfNumber, in: labelText)
                attributedString.addAttribute(.foregroundColor, value: BridgeColor.primary1, range: nsRange)
            }

            periodLabel.attributedText = attributedString

        } else if let startDate = data.startDate {  // startDate만 Date일 경우
            let startDateString = startDate.toString(format: "yyyy.MM.dd")
            periodLabel.text = "\(startDateString)~미정"

        } else if let endDate = data.endDate {  // endDate만 Date일 경우
            let endDateString = endDate.toString(format: "yyyy.MM.dd")
            periodLabel.text = "미정~\(endDateString)"

        } else {  // 둘 다 nil 일 경우
            periodLabel.text = "미정"
        }

        deadlineLabel.text = data.deadline.toString(format: "yyyy.MM.dd")
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
    }
}
