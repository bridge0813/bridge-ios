//
//  BridgeTextView.swift
//  Bridge
//
//  Created by 엄지호 on 2023/10/25.
//

import UIKit
import FlexLayout
import PinLayout
import RxSwift
import RxCocoa

final class BridgeTextView: BaseView {
    // MARK: - UI
    private let rootFlexContainer: UIView = {
        let view = UIView()
        view.layer.borderColor = BridgeColor.gray06.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        
        return view
    }()
    
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.text = textViewPlaceholder
        textView.font = BridgeFont.body2.font
        textView.textColor = BridgeColor.gray04
        textView.textContainerInset = UIEdgeInsets(top: 16, left: 10, bottom: 0, right: 10)
        
        return textView
    }()
    
    private lazy var countLabel: UILabel = {
        let label = UILabel()
        label.textColor = BridgeColor.gray04
        label.font = BridgeFont.caption1.font
        label.backgroundColor = .clear
        label.text = "0/\(maxCount)"
        label.textAlignment = .right
        
        return label
    }()
    
    // MARK: - Property
    var resultText: Observable<String> {
        return textView.rx.didEndEditing
            .withLatestFrom(textView.rx.text.orEmpty)
            .distinctUntilChanged()
    }
    
    private let textViewPlaceholder: String
    private let maxCount: Int
    
    init(textViewPlaceholder: String, maxCount: Int) {
        self.textViewPlaceholder = textViewPlaceholder
        self.maxCount = maxCount
        super.init(frame: .zero)
    }
    
    // MARK: - Layout
    override func configureLayouts() {
        addSubview(rootFlexContainer)
        
        rootFlexContainer.flex.define { flex in
            flex.addItem(textView).grow(1)
            flex.addItem(countLabel).alignSelf(.end).width(100).marginTop(5).marginRight(12).marginBottom(12)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        rootFlexContainer.pin.all()
        rootFlexContainer.flex.layout()
    }
    
    // MARK: - bind
    override func bind() {
        // 유저가 텍스트 뷰를 터치했을 때, 플레이스 홀더를 제거
        textView.rx.didBeginEditing
            .asDriver()
            .drive(onNext: { [weak self] in
                guard let self else { return }
                
                if self.textView.text == self.textViewPlaceholder {
                    self.textView.text = nil
                    self.textView.textColor = BridgeColor.gray01
                }
            })
            .disposed(by: disposeBag)

        // 유저가 입력을 시작하면서 이벤트 발생 && 플레이스 홀더를 텍스트로 지정하면서 이벤트 발생.
        // 발생 시 아무런 텍스트를 입력하지 않았지만, 텍스트 뷰가 활성화되기 때문에 이를 방지하기 위해 조건(텍스트 존재)을 추가
        // 입력된 텍스트가 없을 경우 라벨의 컬러는 변경되지 않고, 라벨 텍스트는 0으로 만들어주어야 하기 때문에 조건을 설정.
        textView.rx.text.orEmpty
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: "Error")
            .drive(onNext: { [weak self] text in
                guard let self else { return }
                
                // 텍스트가 빈 문자열이지 않고, 텍스트홀더도 아닐 경우 활성화
                if !text.isEmpty && text != self.textViewPlaceholder {
                    self.updateCountLabel(text.count)
                    self.rootFlexContainer.layer.borderColor = BridgeColor.primary1.cgColor
                    
                } else if text.isEmpty {
                    self.countLabel.text = "0/\(maxCount)"
                }
                
                // 텍스트가 제한된 글자 수를 초과하면 잘라내기.
                if text.count > self.maxCount {
                    let index = text.index(text.startIndex, offsetBy: self.maxCount)
                    self.textView.text = String(text[..<index])
                }
            })
            .disposed(by: disposeBag)

        // 유저가 입력을 그만두었을 때
        textView.rx.didEndEditing
            .asDriver()
            .drive(onNext: { [weak self] in
                guard let self else { return }
                
                if self.textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    self.textView.text = self.textViewPlaceholder
                    self.textView.textColor = BridgeColor.gray04
                }
                
                self.rootFlexContainer.layer.borderColor = BridgeColor.gray06.cgColor
                self.countLabel.textColor = BridgeColor.gray04
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - UpdateCountLabel
extension BridgeTextView {
    private func updateCountLabel(_ count: Int) {
        let labelText = "\(count)/\(maxCount)"
        let attributedString = NSMutableAttributedString(string: labelText)

        if let rangeOfNumber = labelText.range(of: String(count)) {
            let nsRange = NSRange(rangeOfNumber, in: labelText)
            attributedString.addAttribute(.foregroundColor, value: BridgeColor.secondary1, range: nsRange)
        }

        countLabel.attributedText = attributedString
    }
}
