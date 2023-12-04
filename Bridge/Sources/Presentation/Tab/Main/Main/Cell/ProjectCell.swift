//
//  MainProjectCell.swift
//  Bridge
//
//  Created by 엄지호 on 2023/10/13.
//

import UIKit
import FlexLayout
import PinLayout
import RxSwift
import RxCocoa

/// 기본적인 모집글을 나타내는 Cell
final class ProjectCell: BaseCollectionViewCell {
    // MARK: - UI
    private let rootFlexContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.02
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 5
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 1.0
        view.layer.borderColor = BridgeColor.gray08.cgColor
        view.clipsToBounds = true
        view.layer.masksToBounds = false
        
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = BridgeColor.gray01
        label.font = BridgeFont.subtitle3Long.font
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 2
        
        return label
    }()
    
    private let dDayLabel: UILabel = {
        let label = UILabel()
        label.textColor = BridgeColor.secondary1
        label.font = BridgeFont.body3.font
        
        return label
    }()
    
    private let bookmarkButton = MainBookmarkButton()
    
    private let recruitNumberLabel: UILabel = {
        let label = UILabel()
        label.textColor = BridgeColor.gray03
        label.font = BridgeFont.body4.font
        
        return label
    }()
    
    private let deadlineLabel: UILabel = {
        let label = UILabel()
        label.textColor = BridgeColor.gray03
        label.font = BridgeFont.body4.font
        
        return label
    }()
    
    // MARK: - Property
    weak var delegate: ProjectCellDelegate?
    private var projectID = 0
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
        bind()
    }
    
    // MARK: - Configuration
    override func configureAttributes() {
        rootFlexContainer.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(backgroundTapped))
        )
    }
    
    @objc private func backgroundTapped(_ sender: UITapGestureRecognizer) {
        delegate?.itemSelected(projectID: projectID)
    }
    
    // MARK: - Layout
    override func configureLayouts() {
        addSubview(rootFlexContainer)
        rootFlexContainer.flex.paddingHorizontal(18).define { flex in
            
            flex.addItem().direction(.row).marginTop(19).define { flex in
                flex.addItem().width(200).height(68).define { flex in
                    flex.addItem(dDayLabel)
                    flex.addItem(titleLabel).marginTop(6)
                }
                flex.addItem().grow(1)
                flex.addItem(bookmarkButton).size(24).marginRight(0)
            }
            
            flex.addItem().backgroundColor(BridgeColor.gray08).height(1).marginTop(24)
            
            flex.addItem().direction(.row).alignItems(.center).marginTop(11).define { flex in
                flex.addItem(recruitNumberLabel).height(14)
                flex.addItem(deadlineLabel).height(14).marginLeft(16)
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        rootFlexContainer.pin.all()
        rootFlexContainer.flex.layout()
        
        rootFlexContainer.layer.shadowPath = UIBezierPath(
            roundedRect: rootFlexContainer.bounds,
            cornerRadius: 8
        ).cgPath
    }
    
    // MARK: - Binding
    override func bind() {
        bookmarkButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.bookmarkButton.isSelected.toggle()
                owner.delegate?.bookmarkButtonTapped(projectID: owner.projectID)
            })
            .disposed(by: disposeBag)
    }
    
    func configureCell(with data: ProjectPreview) {
        titleLabel.configureTextWithLineHeight(text: data.title, lineHeight: 24)
        dDayLabel.text = "D-\(data.dDays)"
        recruitNumberLabel.text = "\(data.totalRecruitNumber)명 모집"
        deadlineLabel.text = "\(data.deadline) 모집 마감"
        bookmarkButton.isBookmarked = data.isBookmarked
        projectID = data.projectID
        
        titleLabel.flex.markDirty()
        recruitNumberLabel.flex.markDirty()
        deadlineLabel.flex.markDirty()
    }
}
