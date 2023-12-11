//
//  ManagementProjectCell.swift
//  Bridge
//
//  Created by 엄지호 on 12/6/23.
//

import UIKit
import FlexLayout
import PinLayout
import RxSwift
import RxCocoa

final class ManagementProjectCell: BaseCollectionViewCell {
    // MARK: - UI
    private let deleteButton: UIButton = {
        let button = UIButton()
        button.setImage(
            UIImage(named: "xmark")?.resize(to: CGSize(width: 18, height: 18)).withRenderingMode(.alwaysTemplate),
            for: .normal
        )
        button.flex.size(18)
        button.tintColor = BridgeColor.gray04
        return button
    }()
    
    private let statusLabel = BridgeFilledChip(backgroundColor: BridgeColor.primary1, type: .long)
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.flex.height(48)
        label.textColor = BridgeColor.gray01
        label.font = BridgeFont.subtitle2.font
        label.numberOfLines = 2
        
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.flex.height(14)
        label.textColor = BridgeColor.gray02
        label.font = BridgeFont.caption1.font
        label.lineBreakMode = .byTruncatingTail
        
        return label
    }()
    
    private let deadlineTitleLabel: UILabel = {
        let label = UILabel()
        label.flex.width(64).height(18)
        label.text = "모집 마감일"
        label.textColor = BridgeColor.gray03
        label.font = BridgeFont.body2.font
        
        return label
    }()
    
    private let deadlineLabel: UILabel = {
        let label = UILabel()
        label.flex.width(100).height(18)
        label.textColor = BridgeColor.gray03
        label.textAlignment = .right
        label.font = BridgeFont.body2.font
        
        return label
    }()
    
    private let goToDetailButton: BridgeButton = {
        let button = BridgeButton(
            title: "프로젝트 상세",
            font: BridgeFont.body2.font,
            backgroundColor: BridgeColor.primary1
        )
        button.flex.width(100%).height(44)
        button.isEnabled = true
        
        return button
    }()
    
    private let menuButtonGroup: BridgeSmallButtonGroup = {
        let buttonGroup = BridgeSmallButtonGroup(("지원자 목록", "프로젝트 상세"))
        buttonGroup.flex.width(100%).height(44)
        return buttonGroup
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    // MARK: - Property
    private var projectID = 0
    
    /// 지원자 목록 or 프로젝트 상세
    var buttonGroupTapped: Observable<(String, Int)> {
        return menuButtonGroup.buttonGroupTapped
            .withUnretained(self)
            .map { owner, title in
                return (title, owner.projectID)
            }
    }
    
    /// 프로젝트 삭제
    var deleteButtonTapped: Observable<Int> {
        return deleteButton.rx.tap
            .withUnretained(self)
            .map { owner, _ in
                return owner.projectID
            }
    }
    
    /// 프로젝트 상세
    var detailButtonTapped: Observable<Int> {
        return goToDetailButton.rx.tap
            .withUnretained(self)
            .map { owner, _ in
                return owner.projectID
            }
    }
    
    // MARK: - Configuration
    override func configureAttributes() {
        contentView.backgroundColor = .white
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.03
        contentView.layer.shadowOffset = CGSize(width: 0, height: 4)
        contentView.layer.shadowRadius = 4
        contentView.layer.cornerRadius = 12
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = BridgeColor.gray08.cgColor
        contentView.clipsToBounds = true
        contentView.layer.masksToBounds = false
    }
    
    func configureCell(with data: ProjectPreview, selectedTap: ManagementTapType) {
        // 상태 라벨
        let statusType = ProjectStatusType(rawValue: data.status) ?? .onGoing
        statusLabel.text = statusType.rawValue
        statusLabel.backgroundColor = statusType.statusColor
        
        // 프로젝트 아이디
        projectID = data.projectID
        
        titleLabel.configureTextWithLineHeight(text: data.title, lineHeight: 24)
        descriptionLabel.text = data.description
        deadlineLabel.text = data.deadline
        
        goToDetailButton.isHidden = selectedTap == .recruitment
        menuButtonGroup.isHidden = selectedTap == .apply
        statusLabel.flex.width(statusLabel.intrinsicContentSize.width).height(26).markDirty()
    }
    
    // MARK: - Layout
    override func configureLayouts() {
        contentView.flex.padding(0, 18, 24, 18).define { flex in
            flex.addItem().direction(.row).justifyContent(.spaceBetween).define { flex in
                flex.addItem(statusLabel).marginTop(24)
                flex.addItem(deleteButton).marginTop(20).marginRight(-4)
            }
            
            flex.addItem(titleLabel).marginTop(8)
            flex.addItem(descriptionLabel).marginTop(6)
            flex.addItem().backgroundColor(BridgeColor.gray06).height(1).marginTop(16)
            
            flex.addItem().direction(.row).justifyContent(.spaceBetween).marginTop(14).define { flex in
                flex.addItem(deadlineTitleLabel)
                flex.addItem(deadlineLabel)
            }
            
            // 두 버튼을 같은 위치에 배정(hidden 처리)
            flex.addItem(goToDetailButton).marginTop(14)
            flex.addItem(menuButtonGroup)
                .position(.absolute)
                .left(18)
                .bottom(24)
                .right(18)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.pin.all()
        contentView.flex.layout()
        
        contentView.layer.shadowPath = UIBezierPath(
            roundedRect: contentView.bounds,
            cornerRadius: 12
        ).cgPath
    }
}

// MARK: - Data Source
extension ManagementProjectCell {
    enum ProjectStatusType: String {
        case accept = "수락"
        case refuse = "거절"
        case pendingResult = "결과 대기중"
        case onGoing = "현재 진행중"
        case complete = "모집완료"
        
        var statusColor: UIColor {
            switch self {
            case .accept, .complete: return BridgeColor.secondary1
            case .refuse: return BridgeColor.systemRed
            case .pendingResult, .onGoing: return BridgeColor.primary1
            }
        }
    }
    
    enum ManagementTapType {
        case apply
        case recruitment
    }
}
