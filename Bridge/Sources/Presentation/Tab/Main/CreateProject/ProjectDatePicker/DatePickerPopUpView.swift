//
//  SetDatePopUpView.swift
//  Bridge
//
//  Created by 엄지호 on 2023/10/31.
//

import UIKit
import FlexLayout
import PinLayout
import RxSwift
import RxCocoa

/// 날짜를 설정해주는 뷰
final class DatePickerPopUpView: BaseView {
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
    
    private let dateLabel: UILabel = {
        let label = UILabel()
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

        return datePicker
    }()
    
    private let completeButton = BridgeButton(
        title: "완료",
        font: BridgeFont.button1.font,
        backgroundColor: BridgeColor.gray4
    )
    
    // MARK: - Properties
    private var type = SetDateType.deadline
    
    private var deadlineDate = Date()
    private var startDate: Date?
    private var endDate: Date?
    
    /// 어떤 날짜를 설정하는지, 무슨 날짜로 결정했는지를 전달.
    var completeButtonTapped: Observable<(type: String, date: Date)> {
        return completeButton.rx.tap
            .withUnretained(self)
            .map { owner, _ in
                owner.hide()
                
                switch owner.type {
                case .deadline: return ("deadline", owner.deadlineDate)
                case .start: return ("start", owner.startDate ?? Date())
                case .end: return ("end", owner.endDate ?? Date())
                }
            }
    }
    
    // MARK: - Layout
    override func configureLayouts() {
        addSubview(rootFlexContainer)
        
        rootFlexContainer.flex.define { flex in
            flex.addItem(dragHandleImageView).alignSelf(.center).width(25).height(7).marginTop(10)
            
            flex.addItem(dateLabel).width(150).height(22).marginTop(30).marginLeft(16)
            
            flex.addItem().backgroundColor(BridgeColor.gray8).height(1).marginTop(8)
            
            flex.addItem(datePicker).marginTop(40).marginHorizontal(16)
           
            flex.addItem().grow(1)
            flex.addItem(completeButton).height(52).marginHorizontal(16).marginBottom(34)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        rootFlexContainer.pin.below(of: self).width(100%).height(547)
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
        datePicker.rx.date.changed
            .withUnretained(self)
            .subscribe(onNext: { owner, date in
                switch owner.type {
                case .deadline: owner.deadlineDate = date
                case .start: owner.startDate = date
                case .end: owner.endDate = date
                }
                
                owner.completeButton.isEnabled = true
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - SetDateType
extension DatePickerPopUpView {
    enum SetDateType {
        case deadline
        case start
        case end
    }
    
    private func setDatePicker() {
        completeButton.isEnabled = false
        let maximumDate = Date().calculateMaximumDate()  // 최대 1년까지만 설정이 가능.
        
        switch type {
        case .deadline:
            dateLabel.text = "모집 마감일"
            datePicker.minimumDate = nil  // 초기화
            datePicker.maximumDate = maximumDate
            datePicker.date = deadlineDate
            
            
        case .start:
            dateLabel.text = "시작일"
            datePicker.minimumDate = nil
            datePicker.maximumDate = endDate ?? maximumDate  // endDate가 존재하지 않는다면, 최대 1년으로 설정.
            datePicker.date = startDate ?? Date()
            
            
        case .end:
            dateLabel.text = "예상 완료일"
            datePicker.minimumDate = startDate
            datePicker.maximumDate = maximumDate
            datePicker.date = endDate ?? Date()
        }
    }
}


// MARK: - PanGesture
extension DatePickerPopUpView {
    @objc
    private func handlePanGesture(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: rootFlexContainer)
        let velocity = sender.velocity(in: rootFlexContainer)
        
        let currentTranslationY: CGFloat = -547  // 초기 컨테이너의 오프셋
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
extension DatePickerPopUpView {
    func show(for type: SetDateType) {
        setLayout()
        self.type = type
        setDatePicker()
        
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            guard let self else { return }
            self.rootFlexContainer.transform = CGAffineTransform(translationX: 0, y: -547)
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
