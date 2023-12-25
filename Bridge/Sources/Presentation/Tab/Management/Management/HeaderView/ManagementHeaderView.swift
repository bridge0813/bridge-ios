//
//  ManagementHeaderView.swift
//  Bridge
//
//  Created by 엄지호 on 12/6/23.
//

import UIKit
import FlexLayout
import PinLayout
import RxSwift
import RxCocoa

final class ManagementHeaderView: BaseCollectionReusableView {
    // MARK: - UI
    private let rootFlexContainer: UIView = {
        let view = UIView()
        view.backgroundColor = BridgeColor.gray10
        return view
    }()
    
    private let allProjectsCountView = ProjectCountView("전체")
    private let dynamicProjectsCountView = ProjectCountView("결과 대기")  // "결과 대기" 와 "현재 진행"으로 변경될 수 있음.
    private let completedProjectsCountView = ProjectCountView("완료")
    
    private let filterButton: UIButton = {
        let button = UIButton()
        let buttonImage = UIImage(named: "chevron.down")?.resize(to: CGSize(width: 12, height: 12))
        
        var configuration = UIButton.Configuration.filled()
        configuration.baseForegroundColor = .clear
        configuration.baseBackgroundColor = .clear
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        configuration.image = buttonImage
        configuration.imagePlacement = .trailing
        configuration.imagePadding = 4
        
        var titleContainer = AttributeContainer()
        titleContainer.font = BridgeFont.body1.font
        titleContainer.foregroundColor = BridgeColor.gray01
        configuration.attributedTitle = AttributedString("전체", attributes: titleContainer)
        
        button.configuration = configuration
        button.contentHorizontalAlignment = .leading
        
        return button
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    // MARK: - Property
    var filterButtonTapped: ControlEvent<Void> {
        return filterButton.rx.tap
    }
    
    var filterButtonTitle: String = "전체" {
        didSet {
            updateFilterButtonTitle()
        }
    }
    
    // MARK: - Configuration
    func configureHeaderView(projects: [ProjectPreview], selectedTab: ManagementTabType) {
        allProjectsCountView.count = projects.count
        dynamicProjectsCountView.count = projects.filter {
            $0.status == "결과 대기중" || $0.status == "현재 모집중"
        }.count
        
        completedProjectsCountView.count = projects.filter {
            $0.status == "모집완료" || $0.status == "수락" || $0.status == "거절"
        }.count
        
        dynamicProjectsCountView.title = selectedTab == .apply ? "결과 대기" : "현재 진행"
    }
    
    private func updateFilterButtonTitle() {
        var updatedConfiguration = filterButton.configuration
        
        var titleContainer = AttributeContainer()
        titleContainer.font = BridgeFont.body1.font
        titleContainer.foregroundColor = BridgeColor.gray01
        updatedConfiguration?.attributedTitle = AttributedString(filterButtonTitle, attributes: titleContainer)
        
        filterButton.configuration = updatedConfiguration
    }
    
    // MARK: - Layout
    override func configureLayouts() {
        addSubview(rootFlexContainer)
        rootFlexContainer.flex.padding(24, 16, 0, 16).define { flex in
            flex.addItem().direction(.row).define { flex in
                flex.addItem(allProjectsCountView).grow(1)
                flex.addItem(dynamicProjectsCountView).grow(1).marginLeft(11)
                flex.addItem(completedProjectsCountView).grow(1).marginLeft(11)
            }
            
            flex.addItem(filterButton).marginTop(24)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        rootFlexContainer.pin.all()
        rootFlexContainer.flex.layout()
    }
}

// MARK: - Data Source
extension ManagementHeaderView {
    enum ManagementTabType {
        case apply
        case recruitment
    }
}
