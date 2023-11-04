//
//  BasePopUpView.swift
//  Bridge
//
//  Created by 엄지호 on 2023/11/03.
//

import UIKit
import FlexLayout
import PinLayout

class BasePopUpView: BaseView {
    // MARK: - UI
    let rootFlexContainer: UIView = {
        let view = UIView()
        view.backgroundColor = BridgeColor.gray10
        view.clipsToBounds = true
        view.layer.cornerRadius = 12
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        return view
    }()
    
    let dragHandleBar: UIView = {
        let view = UIView()
        view.backgroundColor = BridgeColor.gray8
        view.clipsToBounds = true
        view.layer.cornerRadius = 2.5
        
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = BridgeFont.subtitle1.font
        label.textColor = BridgeColor.gray1
        
        return label
    }()
    
    let completeButton: BridgeButton = {
        let button = BridgeButton(
            title: "완료",
            font: BridgeFont.button1.font,
            backgroundColor: BridgeColor.gray4
        )
        button.isEnabled = false
        
        return button
    }()
    
    // MARK: - Properties
    /// 팝업 뷰의 높이(상속받는 객체는 이를 설정해주어야 함)
    var containerHeight: CGFloat { 0 }
    
    /// 드래그로 뷰를 어느 정도까지 내렸을 때 dismiss할 것인지 결정하는 y
    var dismissYPosition: CGFloat { 0 }
    
    
    // MARK: - Layout
    override func configureLayouts() {
        addSubview(rootFlexContainer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        rootFlexContainer.pin.below(of: self).width(100%).height(containerHeight)
        rootFlexContainer.flex.layout()
    }
    
    // MARK: - Configure
    override func configureAttributes() {
        backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        rootFlexContainer.addGestureRecognizer(panGesture)
    }
    
    // MARK: - HandleGesture
    @objc
    private func handlePanGesture(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: rootFlexContainer)
        let velocity = sender.velocity(in: rootFlexContainer)
        
        let currentTranslationY: CGFloat = -containerHeight  // 초기 컨테이너의 오프셋
        let calculatedTranslationY = currentTranslationY + translation.y  // 초기 오프셋을 고려한 결과값
        
        switch sender.state {
        case .changed:
            // 아래로 드래그하거나 최대 높이 이내에서만 transform을 적용
            if calculatedTranslationY > currentTranslationY && calculatedTranslationY <= 0 {
                rootFlexContainer.transform = CGAffineTransform(translationX: 0, y: calculatedTranslationY)
            }
            
        case .ended:
            if velocity.y > 1500 || calculatedTranslationY > -dismissYPosition {
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
    
    // MARK: - Show & Hide
    func show() {
        setLayout()
        
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            guard let self else { return }
            self.rootFlexContainer.transform = CGAffineTransform(translationX: 0, y: -containerHeight)
        })
    }

    private func setLayout() {
        let window = UIWindow.visibleWindow() ?? UIWindow()
        window.addSubview(self)
        window.bringSubviewToFront(self)
        
        pin.all()
    }
    
    func hide() {
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
