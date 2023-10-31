//
//  SetDeadlinePopUpView.swift
//  Bridge
//
//  Created by 엄지호 on 2023/10/31.
//

import UIKit
import FlexLayout
import PinLayout
import RxSwift
import RxCocoa

/// 모집인원을 선택하는 뷰
final class SetDeadlinePopUpView: BaseView {
    // MARK: - UI
    private let rootFlexContainer: UIView = {
        let view = UIView()
        view.backgroundColor = BridgeColor.gray10
        view.clipsToBounds = true
        view.layer.cornerRadius = 12
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        return view
    }()
    
    private let dragHandleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "draghandle")
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private let deadlineLabel: UILabel = {
        let label = UILabel()
        label.text = "모집 마감일"
        label.font = BridgeFont.subtitle1.font
        label.textColor = BridgeColor.gray1
        
        return label
    }()
    
    private let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.locale = Locale(identifier: "ko-KR")
        datePicker.tintColor = BridgeColor.primary1
        datePicker.preferredDatePickerStyle = .inline
        datePicker.datePickerMode = .date
        datePicker.date = Date()
        
        return datePicker
    }()
    
    private let completeButton: BridgeButton = {
        let button = BridgeButton(
            title: "완료",
            font: BridgeFont.button1.font,
            backgroundColor: BridgeColor.gray4
        )
        button.isEnabled = false
        
        return button
    }()
    
    // MARK: - Properties
    var completeButtonTapped: Observable<Int> {
        return completeButton.rx.tap
            .withUnretained(self)
            .map { owner, _ in
                owner.hide()
                return 1
            }
            .distinctUntilChanged()
    }
    
    
    // MARK: - Layout
    override func configureLayouts() {
        addSubview(rootFlexContainer)
        
        rootFlexContainer.flex.define { flex in
            flex.addItem(dragHandleImageView).alignSelf(.center).width(25).height(7).marginTop(10)
            
            flex.addItem(deadlineLabel).width(83).height(22).marginTop(30).marginLeft(16)
            
            flex.addItem().backgroundColor(BridgeColor.gray8).height(1).marginTop(7)
            
            flex.addItem(datePicker).marginTop(32).marginHorizontal(16)
           
            flex.addItem(completeButton).height(52).marginHorizontal(16).marginBottom(16)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        rootFlexContainer.pin.below(of: self).width(100%).height(529)
        rootFlexContainer.flex.layout()
    }
    
    // MARK: - Configure
    override func configureAttributes() {
        backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        rootFlexContainer.addGestureRecognizer(panGesture)
    }

    // MARK: - Bind
    override func bind() {
        
    }
}


// MARK: - PanGesture
extension SetDeadlinePopUpView {
    @objc
    private func handlePanGesture(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: rootFlexContainer)
        let velocity = sender.velocity(in: rootFlexContainer)
        
        let currentTranslationY: CGFloat = -529  // 초기 컨테이너의 오프셋
        let calculatedTranslationY = currentTranslationY + translation.y  // 초기 오프셋을 고려한 결과값
        
        switch sender.state {
        case .changed:
            // 아래로 드래그하거나 최대 높이 이내에서만 transform을 적용
            if calculatedTranslationY > currentTranslationY && calculatedTranslationY <= 0 {
                rootFlexContainer.transform = CGAffineTransform(translationX: 0, y: calculatedTranslationY)
            }
            
        case .ended:
            if velocity.y > 1500 {
                hide()
                
            } else if calculatedTranslationY > -300 {
                hide()
                
            } else {  // 원상복구
                UIView.animate(withDuration: 0.2) {
                    self.rootFlexContainer.transform = CGAffineTransform(translationX: 0, y: currentTranslationY)
                }
            }
            
        default:
            break
        }
    }
}

// MARK: - Show & Hide
extension SetDeadlinePopUpView {
    func show() {
        setLayout()
        
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            guard let self else { return }
            self.rootFlexContainer.transform = CGAffineTransform(translationX: 0, y: -529)
        })
    }

    private func setLayout() {
        let window = UIWindow.visibleWindow() ?? UIWindow()
        window.addSubview(self)
        window.bringSubviewToFront(self)
        
        pin.all()
    }
    
    private func hide() {
        UIView.animate(
            withDuration: 0.2,
            animations: { [weak self] in
                guard let self else { return }
                self.rootFlexContainer.transform = .identity
                
            }, completion: { [weak self] _ in
                guard let self else { return }
                self.removeFromSuperview()
            }
        )
    }
}
