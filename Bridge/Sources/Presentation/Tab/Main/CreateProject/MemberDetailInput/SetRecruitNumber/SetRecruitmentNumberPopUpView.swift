//
//  SetRecruitmentNumberView.swift
//  Bridge
//
//  Created by 엄지호 on 2023/10/27.
//

import UIKit
import FlexLayout
import PinLayout
import RxSwift
import RxCocoa

/// 모집인원을 선택하는 뷰
final class SetRecruitmentNumberPopUpView: BaseView {
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
    
    private let recruitLabel: UILabel = {
        let label = UILabel()
        label.text = "모집 인원"
        label.font = BridgeFont.subtitle1.font
        label.textColor = BridgeColor.gray1
        
        return label
    }()
    
    private lazy var pickerView: UIPickerView = {
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        
        return picker
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
                let selectedRow = owner.pickerView.selectedRow(inComponent: 0)
                return selectedRow + 1
            }
            .distinctUntilChanged()
    }
    
    
    // MARK: - Layout
    override func configureLayouts() {
        addSubview(rootFlexContainer)
        
        rootFlexContainer.flex.define { flex in
            flex.addItem(dragHandleImageView).alignSelf(.center).width(25).height(7).marginTop(10)
            
            flex.addItem(recruitLabel).width(67).height(22).marginTop(30).marginLeft(16)
            
            flex.addItem().backgroundColor(BridgeColor.gray8).height(1).marginTop(7)
            
            flex.addItem(pickerView).height(120).marginTop(56)
            
            flex.addItem().grow(1)
            flex.addItem(completeButton).height(52).marginHorizontal(16).marginBottom(50)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        rootFlexContainer.pin.below(of: self).width(100%).height(409)
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
        pickerView.rx.itemSelected
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.completeButton.isEnabled = true
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - PickerDelegate
extension SetRecruitmentNumberPopUpView: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 10
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        // selection indicator 제거
        pickerView.subviews.forEach { view in
            view.backgroundColor = .clear
        }
        
        let label = UILabel()
        
        label.text = ["1명", "2명", "3명", "4명", "5명", "6명", "7명", "8명", "9명", "10명"][row]
        label.textColor = BridgeColor.gray1
        label.font = BridgeFont.headline1.font
        label.textAlignment = .center
        
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40
    }
}

// MARK: - PanGesture
extension SetRecruitmentNumberPopUpView {
    @objc
    private func handlePanGesture(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: rootFlexContainer)
        let velocity = sender.velocity(in: rootFlexContainer)
        
        let currentTranslationY: CGFloat = -409  // 초기 컨테이너의 오프셋
        let calculatedTranslationY = currentTranslationY + translation.y  // 초기 오프셋을 고려한 결과값
        
        switch sender.state {
        case .changed:
            // 아래로 드래그하거나 최대 높이 이내에서만 transform을 적용
            if calculatedTranslationY > currentTranslationY && calculatedTranslationY <= 0 {
                rootFlexContainer.transform = CGAffineTransform(translationX: 0, y: calculatedTranslationY)
            }
            
        case .ended:
            if velocity.y > 1500 || calculatedTranslationY > -250 {
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
extension SetRecruitmentNumberPopUpView {
    func show() {
        setLayout()
        
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            guard let self else { return }
            self.rootFlexContainer.transform = CGAffineTransform(translationX: 0, y: -409)
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
