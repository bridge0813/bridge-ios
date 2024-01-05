//
//  AddLinkPopUpView.swift
//  Bridge
//
//  Created by 엄지호 on 1/5/24.
//

import UIKit
import FlexLayout
import PinLayout
import RxSwift
import RxCocoa

/// 모집인원을 선택하는 뷰
final class AddLinkPopUpView: BridgeBasePopUpView {
    // MARK: - UI
    private let textView: UITextView = {
        let textView = UITextView()
        textView.flex.height(74)
        textView.text = "URL형식으로 적어주세요."  // Placeholder
        textView.font = BridgeFont.body2.font
        textView.textColor = BridgeColor.gray04
        textView.textContainerInset = UIEdgeInsets(top: 16, left: 12, bottom: 16, right: 12)
        textView.layer.borderWidth = 1
        textView.layer.borderColor = BridgeColor.gray06.cgColor
        textView.layer.cornerRadius = 8
        textView.clipsToBounds = true
        
        return textView
    }()
    // MARK: - Property
    override var containerHeight: CGFloat { 262 }
    override var dismissYPosition: CGFloat { 130 }
    
    private var linkURL = ""
    var addedLinkURL: Observable<String> {
        return completeButton.rx.tap
            .withUnretained(self)
            .map { owner, _ in
                owner.hide()
                return owner.linkURL
            }
    }
    
    // MARK: - Configuration
    override func configureAttributes() {
        super.configureAttributes()
        titleLabel.text = "참고 링크"
        completeButton.setTitle("저장", for: .normal)
        
        // 키보드 hide
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Layout
    override func configureLayouts() {
        super.configureLayouts()
        
        rootFlexContainer.flex.paddingHorizontal(16).define { flex in
            flex.addItem(dragHandleBar).alignSelf(.center).marginTop(10)
            flex.addItem(titleLabel).width(67).height(22).marginTop(30)
            flex.addItem().backgroundColor(BridgeColor.gray08).height(1).marginTop(7).marginHorizontal(-16)
            flex.addItem(textView).marginTop(32)
            flex.addItem(completeButton).height(52).marginTop(18)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }

    // MARK: - Bind
    override func bind() {
        // TextView 플레이스홀더 구현
        textView.rx.didBeginEditing
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                if owner.textView.text == "URL형식으로 적어주세요." {
                    owner.textView.text = nil
                    owner.textView.textColor = BridgeColor.gray01
                }
            })
            .disposed(by: disposeBag)
        
        textView.rx.didEndEditing
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                if owner.textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    owner.textView.text = "URL형식으로 적어주세요."
                    owner.textView.textColor = BridgeColor.gray04
                }
            })
            .disposed(by: disposeBag)
        
        // 입력한 텍스트 저장
        textView.rx.text.orEmpty
            .distinctUntilChanged()
            .withUnretained(self)
            .subscribe(onNext: { owner, text in
                owner.linkURL = text
                // 텍스트가 비어있지 않고 && 플레이스홀더가 아닐 경우에만 활성화
                owner.completeButton.isEnabled = !text.isEmpty && text != "URL형식으로 적어주세요."
            })
            .disposed(by: disposeBag)
        
        // 키보드 반응 구현
        rootFlexContainer.rx.keyboardLayoutChanged
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { owner, keyboardHeight in
                UIView.animate(withDuration: 0.3) {
                    // 키보드가 내려갔을 경우
                    guard keyboardHeight > 0 else {
                        owner.rootFlexContainer.transform = CGAffineTransform(translationX: 0, y: -owner.containerHeight)
                        return
                    }
                
                    owner.rootFlexContainer.transform = CGAffineTransform(translationX: 0, y: -(keyboardHeight + owner.containerHeight))
                }
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - HandleGesture
    override func handlePanGesture(sender: UIPanGestureRecognizer) {
        textView.resignFirstResponder()
        super.handlePanGesture(sender: sender)
    }
    
    @objc private func hideKeyboard(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: self)
        if !rootFlexContainer.frame.contains(location) {
            textView.resignFirstResponder()
        }
    }
    
    // MARK: - Hide
    override func show() {
        // 초기화
        textView.text = "URL형식으로 적어주세요."
        textView.textColor = BridgeColor.gray04
        super.show()
    }
    override func hide() {
        textView.resignFirstResponder()
        super.hide()
    }
}
