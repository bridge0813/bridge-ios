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
        textView.text = placeholder
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
    
    /// TextView의 text
    var text = "" {
        didSet {
            textView.text = text
            textView.textColor = textColor
            countLabel.text = "\(text.count)/\(maxCount)"
        }
    }
    
    private let placeholder: String
    private let maxCount: Int
    private let textColor: UIColor
    
    init(placeholder: String, maxCount: Int, textColor: UIColor = BridgeColor.gray01) {
        self.placeholder = placeholder
        self.maxCount = maxCount
        self.textColor = textColor
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
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                if owner.textView.text == owner.placeholder {
                    owner.textView.text = nil
                    owner.textView.textColor = owner.textColor
                }
            })
            .disposed(by: disposeBag)

        // 유저가 입력을 시작하면서 이벤트 발생 && 플레이스 홀더를 텍스트로 지정하면서 이벤트 발생.
        // 발생 시 아무런 텍스트를 입력하지 않았지만, 텍스트 뷰가 활성화되기 때문에 이를 방지하기 위해 조건(텍스트 존재)을 추가
        // 입력된 텍스트가 없을 경우 라벨의 컬러는 변경되지 않고, 라벨 텍스트는 0으로 만들어주어야 하기 때문에 조건을 설정.
        textView.rx.text.orEmpty
            .distinctUntilChanged()
            .withUnretained(self)
            .subscribe(onNext: { owner, text in
                // 텍스트가 빈 문자열이지 않고 && 플레이스홀더가 아니고 && 설정한 텍스트가 아닐 경우 활성화
                if !text.isEmpty && text != owner.placeholder && text != owner.text {
                    owner.updateCountLabel(text.count)
                    owner.rootFlexContainer.layer.borderColor = BridgeColor.primary1.cgColor
                    
                } else if text.isEmpty {
                    owner.countLabel.text = "0/\(owner.maxCount)"
                }
                
                // 텍스트가 제한된 글자 수를 초과하면 잘라내기.
                if text.count > owner.maxCount {
                    let index = text.index(text.startIndex, offsetBy: owner.maxCount)
                    owner.textView.text = String(text[..<index])
                }
            })
            .disposed(by: disposeBag)

        // 유저가 입력을 그만두었을 때
        textView.rx.didEndEditing
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                if owner.textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    owner.textView.text = self.placeholder
                    owner.textView.textColor = BridgeColor.gray04
                }
                
                owner.rootFlexContainer.layer.borderColor = BridgeColor.gray06.cgColor
                owner.countLabel.textColor = BridgeColor.gray04
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - UpdateCountLabel
extension BridgeTextView {
    private func updateCountLabel(_ count: Int) {
        countLabel.highlightedTextColor(
            text: "\(count)/\(maxCount)",
            highlightedText: String(count),
            hignlightedTextColor: BridgeColor.secondary1
        )
    }
}
