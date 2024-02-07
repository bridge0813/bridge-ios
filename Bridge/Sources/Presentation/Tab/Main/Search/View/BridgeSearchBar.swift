//
//  BridgeSearchBar.swift
//  Bridge
//
//  Created by 엄지호 on 2/6/24.
//

import UIKit
import FlexLayout
import PinLayout
import RxSwift
import RxCocoa

final class BridgeSearchBar: BaseView {
    // MARK: - UI
    private let rootFlexContainer: UIView = {
        let view = UIView()
        view.layer.borderColor = BridgeColor.primary1.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        return view
    }()
    
    private let searchImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.flex.size(24)
        imageView.image = UIImage(named: "magnifyingglass")?.resize(to: CGSize(width: 24, height: 24)).withRenderingMode(.alwaysTemplate)
        imageView.tintColor = BridgeColor.primary1
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let textField: UITextField = {
        let textField = UITextField()
        textField.flex.height(20)
        textField.attributedPlaceholder = NSAttributedString(
            string: "검색어를 입력해주세요.",
            attributes: [.foregroundColor: BridgeColor.gray04]
        )
        textField.font = BridgeFont.body2.font
        textField.textColor = BridgeColor.gray01
        textField.returnKeyType = .search
        return textField
    }()
    
    private let deleteButton: UIButton = {
        let button = UIButton()
        button.flex.size(20)
        button.setImage(
            UIImage(named: "delete.circle")?
                .resize(to: CGSize(width: 20, height: 20))
                .withRenderingMode(.alwaysTemplate),
            for: .normal
        )
        button.tintColor = BridgeColor.gray04
        button.isHidden = true
        return button
    }()
    
    // MARK: - Property
    var editingDidBegin: Observable<Void> {
        return textField.rx.controlEvent(.editingDidBegin).asObservable()
    }
    
    var searchButtonTapped: Observable<String> {
        return textField.rx.controlEvent(.editingDidEndOnExit)
            .withLatestFrom(textField.rx.text.orEmpty)
    }
    
    // MARK: - Configuration
    override func configureAttributes() {
        textField.becomeFirstResponder()
    }
    
    // MARK: - Layout
    override func configureLayouts() {
        addSubview(rootFlexContainer)
        
        rootFlexContainer.flex.direction(.row).alignItems(.center).paddingHorizontal(20).define { flex in
            flex.addItem(searchImageView)
            flex.addItem(textField).marginLeft(5).grow(1)
            flex.addItem(deleteButton).marginLeft(10).marginRight(0)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        rootFlexContainer.pin.all()
        rootFlexContainer.flex.layout()
    }
    
    // MARK: - bind
    override func bind() {
        deleteButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.textField.text = ""
                owner.deleteButton.isHidden = true
            })
            .disposed(by: disposeBag)
        
        // 텍스트 필드에 텍스트 여부에 따라 삭제 버튼 활성화
        textField.rx.text
            .orEmpty
            .distinctUntilChanged()
            .map { $0.isEmpty }
            .bind(to: deleteButton.rx.isHidden)
            .disposed(by: disposeBag)
    }
}
