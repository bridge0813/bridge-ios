//
//  BookmarkedProjectCell.swift
//  Bridge
//
//  Created by 정호윤 on 12/23/23.
//

import UIKit
import FlexLayout
import PinLayout
import RxSwift

final class BookmarkedProjectCell: BaseCollectionViewCell {
    // MARK: - UI
    private let bookmarkButton: UIButton = {
        let button = UIButton()
        button.flex.width(40).height(32)
        button.setImage(UIImage(named: "bookmark.fill")?.resize(to: CGSize(width: 20, height: 20)).withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = BridgeColor.primary1
        button.contentHorizontalAlignment = .right
        button.contentVerticalAlignment = .top
        return button
    }()
    
    private let dueDateLabel: UILabel = {
        let label = UILabel()
        label.font = BridgeFont.body3.font
        label.textColor = BridgeColor.secondary1
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = BridgeFont.body2Long.font
        label.textColor = BridgeColor.gray01
        label.numberOfLines = 0
        return label
    }()
    
    private let totalRecruitNumberLabel: UILabel = {
        let label = UILabel()
        label.font = BridgeFont.body4.font
        label.textColor = BridgeColor.gray03
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = BridgeFont.body4.font
        label.textColor = BridgeColor.gray03
        return label
    }()
    
    // MARK: - Preparation
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    // MARK: - Configuration
    override func configureAttributes() {
        contentView.backgroundColor = BridgeColor.gray10
        contentView.layer.cornerRadius = 8
        contentView.clipsToBounds = true
    }
    
    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.pin.all()
        contentView.flex.layout()
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        contentView.pin.all()
        contentView.flex.layout(mode: .adjustHeight)
        return contentView.frame.size
    }
    
    override func configureLayouts() {
        contentView.flex.padding(12, 16).define { flex in
            flex.addItem().direction(.row).justifyContent(.spaceBetween).height(32).define { flex in
                flex.addItem(dueDateLabel).marginTop(18)
                flex.addItem(bookmarkButton).marginRight(-4)
            }
            flex.addItem(titleLabel).marginTop(6).width(120)
            
            flex.addItem().grow(1)
            flex.addItem().height(1).backgroundColor(BridgeColor.gray09)
            
            flex.addItem(totalRecruitNumberLabel).marginTop(12)
            flex.addItem(dateLabel).marginTop(8)
        }
    }
}

// MARK: - Configuration
extension BookmarkedProjectCell {
    func configure(with bookmarkedProject: BookmarkedProject) {
        if let dDay = bookmarkedProject.dDay {
            dueDateLabel.text = "D - \(dDay)"
        } else {
            dueDateLabel.text = "날짜 미정"
        }
        
        titleLabel.text = bookmarkedProject.title
        totalRecruitNumberLabel.text = "\(bookmarkedProject.totalRecruitNumber)명 모집"
        
        let startDate = bookmarkedProject.startDate ?? "날짜미정"
        let endDate = bookmarkedProject.endDate ?? "날짜미정"
        
        // startDate와 endDate 모두 미정일 경우
        if startDate == "날짜미정", endDate == "날짜미정" {
            dateLabel.text = "날짜미정"
        } else {
            dateLabel.text = "\(startDate) - \(endDate)"
        }
        
        dueDateLabel.flex.markDirty()
        titleLabel.flex.markDirty()
        totalRecruitNumberLabel.flex.markDirty()
        dateLabel.flex.markDirty()
        
        contentView.flex.layout()
    }
}

// MARK: - Observable
extension BookmarkedProjectCell {
    var bookmarkButtonTapped: Observable<Void> {
        bookmarkButton.rx.tap.asObservable()
    }
}
