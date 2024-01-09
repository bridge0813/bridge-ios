//
//  EditProfileTechStackCell.swift
//  Bridge
//
//  Created by 엄지호 on 1/1/24.
//

import UIKit
import FlexLayout
import PinLayout
import RxSwift
import RxCocoa

final class EditProfileTechStackCell: BaseTableViewCell {
    // MARK: - UI
    private let rootFlexContainer: UIView = {
        let view = UIView()
        view.backgroundColor = BridgeColor.gray09
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        return view
    }()
    
    private let fieldLabel: UILabel = {
        let label = UILabel()
        label.font = BridgeFont.body2.font
        return label
    }()
    
    private let menuButton: UIButton = {
        let button = UIButton()
        button.flex.size(24)
        button.setImage(UIImage(named: "kebab")?.resize(to: CGSize(width: 24, height: 24)), for: .normal)
        return button
    }()
    
    private lazy var menuDropdown = DropDown(
        anchorView: menuButton,
        bottomOffset: CGPoint(x: -80, y: 0),
        dataSource: ["수정하기", "삭제하기"],
        cellHeight: 44,
        itemTextColor: BridgeColor.gray03,
        itemTextFont: BridgeFont.body2.font,
        width: 91,
        cornerRadius: 4
    )
    
    private let tagContainer = UIView()
    private var tags: [BridgeTechStackTag] = []
    
    // MARK: - Preparation
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
        bind()
        tags.forEach { tag in
            tag.removeFromSuperview()
        }
    }
    
    // MARK: - Property
    var indexRow: IndexRow = 0
    
    /// 선택된 옵션과 대상이 되는 Cell의 indexRow
    var dropdownItemSelected: Observable<(String, IndexRow)> {
        menuDropdown.itemSelected
            .withUnretained(self)
            .map { owner, item in
                return  (item.title, owner.indexRow)
            }
    }
    
    // MARK: - Layout
    private func configureLayout() {
        contentView.flex.define { flex in
            flex.addItem(rootFlexContainer).padding(20, 14, 18, 14).marginBottom(8).define { flex in
                flex.addItem(fieldLabel)
                flex.addItem(menuButton).position(.absolute).top(17).right(6)
                
                flex.addItem(tagContainer)
                    .direction(.row)
                    .alignItems(.start)
                    .wrap(.wrap)
                    .marginTop(12)
                    .define { flex in
                        tags.forEach { tag in
                            flex.addItem(tag).height(38).marginRight(8).marginBottom(8)
                        }
                    }
            }
        }
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        contentView.pin.all()
        contentView.flex.layout(mode: .adjustHeight)
        return contentView.frame.size
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.pin.all()
        contentView.flex.layout()
    }
    
    // MARK: - Binding
    override func bind() {
        menuButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                // 드롭다운 레이아웃 재계산(anchorView의 레이아웃 배치 후 드롭다운 위치설정)
                owner.menuDropdown.updateDropdownLayout()
                
                // 기존 배경 레이아웃 제거(스크롤에 의한 충돌방지)
                owner.menuDropdown.removeConstraints(owner.menuDropdown.constraints)
                
                // show(배경 레이아웃을 다시 잡아줌)
                owner.menuDropdown.show()
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Configuration
extension EditProfileTechStackCell {
    func configure(with fieldTeckStack: FieldTechStack) {
        let category = fieldTeckStack.field.categoryForField()
        let field = fieldTeckStack.field
        
        // 속성 정의
        let attributes: [String: [NSAttributedString.Key: Any]] = [
            category: [.foregroundColor: BridgeColor.gray01],
            "/": [.foregroundColor: BridgeColor.gray05],
            field: [.foregroundColor: BridgeColor.secondary1]
        ]
        let attributedString = NSMutableAttributedString(string: "\(category) / \(field)")

        // 각 부분에 속성 적용
        attributes.forEach { key, attrs in
            let range = ("\(category) / \(field)" as NSString).range(of: key)
            attributedString.addAttributes(attrs, range: range)
        }

        // 텍스트 적용
        fieldLabel.attributedText = attributedString

        // 태그버튼 생성
        let tags = fieldTeckStack.techStacks.map { tagName in
            return BridgeTechStackTag(
                tagName: tagName,
                textColor: BridgeColor.gray02,
                backgroundColor: BridgeColor.gray10
            )
        }
        self.tags = tags
        configureLayout()
    }
}
