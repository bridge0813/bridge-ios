//
//  BridgePlaceholderView.swift
//  Bridge
//
//  Created by 정호윤 on 2023/09/14.
//

import UIKit
import FlexLayout
import PinLayout

final class BridgePlaceholderView: BaseView {
    
    private let rootFlexContainer: UIView = {
        let view = UIView()
        view.backgroundColor = BridgeColor.gray09
        return view
    }()
    
    private let emojiImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = BridgeFont.subtitle2.font
        label.textColor = BridgeColor.gray01
        label.textAlignment = .center
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = BridgeFont.body2.font
        label.textColor = BridgeColor.gray04
        label.textAlignment = .center
        label.numberOfLines = 0
        
        return label
    }()
    
    init(description: String? = nil) {
        descriptionLabel.text = description
        super.init(frame: .zero)
    }
    
    override func configureLayouts() {
        addSubview(rootFlexContainer)
        
        rootFlexContainer.flex.justifyContent(.center).alignItems(.center).define { flex in
            flex.addItem(emojiImageView).size(100)
            flex.addItem(titleLabel).marginTop(4)
            flex.addItem(descriptionLabel).marginTop(6)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        rootFlexContainer.pin.all(pin.safeArea)
        rootFlexContainer.flex.layout()
    }
}

extension BridgePlaceholderView {
    enum PlaceholderType {
        case needSignIn
        case error
        case emptyChannel
        
        case comingSoon
        case emptyProject         // Main에서 보여주는 모집글이 없을 경우
        
        case emptyAppliedProject  // 지원한 모집글이 없을 경우
        case emptyMyProject       // 작성한 모집글이 없을 경우
        case emptyApplicantList   // 지원자 목록이 비어있을 경우
    }
    
    struct PlaceholderConfiguration {
        let title: String
        let description: String
    }
    
    func configurePlaceholderView(for type: PlaceholderType, configuration: PlaceholderConfiguration? = nil) {
        switch type {
        case .needSignIn:
            emojiImageView.image = UIImage(named: "graphic_sign_in")
            titleLabel.text = "로그인 후 사용 가능해요!"
            descriptionLabel.text = "로그인 후 사용 가능한 기능입니다."
            
        case .error:
            emojiImageView.image = UIImage(named: "graphic_warning")
            titleLabel.text = "오류가 발생했습니다."
            descriptionLabel.text = "잠시 후 다시 시도해 주세요."
            
        case .emptyChannel:
            emojiImageView.image = UIImage(named: "graphic_chat")
            titleLabel.text = "현재 채팅이 없어요!"
            descriptionLabel.text = "예비 팀원과 새로운 채팅을 시작해보세요."
            
        case .comingSoon:
            emojiImageView.image = UIImage(named: "graphic_lock")
            titleLabel.text = "출시 예정이에요!"
            descriptionLabel.text = "빠른 시일 내에 소개할 수 있도록 \n브릿지가 노력할게요:)"
            
        case .emptyProject:
            emojiImageView.image = UIImage(named: "graphic_search")
            titleLabel.text = "올라온 모집글이 없어요!"
            descriptionLabel.text = "조금만 기달려 주세요."
            
        case .emptyAppliedProject:
            emojiImageView.image = UIImage(named: "graphic_support")
            titleLabel.text = "프로젝트에 지원해보세요!"
            descriptionLabel.text = "팀원들이 당신을 기다리고 있어요."
            
        case .emptyMyProject:
            emojiImageView.image = UIImage(named: "graphic_recruitment")
            titleLabel.text = "프로젝트 모집하셨나요?"
            descriptionLabel.text = "브릿지에서 간편하게 모집글 올리고\n함께할 팀원을 찾아보세요."
            
        case .emptyApplicantList:
            emojiImageView.image = UIImage(named: "graphic_loading")
            titleLabel.text = "아직 지원자가 없어요!"
            descriptionLabel.text = "지원자가 생기면 알려드릴게요."
        }
        
        if let configuration {
            titleLabel.text = configuration.title
            descriptionLabel.text = configuration.description
        }

        emojiImageView.flex.markDirty()
        titleLabel.flex.markDirty()
        descriptionLabel.flex.markDirty()
        rootFlexContainer.flex.layout()
    }
}
