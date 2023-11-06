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
final class DatePickerPopUpView: BridgeBasePopUpView {
    // MARK: - UI
    private let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.locale = Locale(identifier: "ko-KR")
        datePicker.tintColor = BridgeColor.primary1
        datePicker.preferredDatePickerStyle = .inline
        datePicker.datePickerMode = .date

        return datePicker
    }()
    
    // MARK: - Properties
    override var containerHeight: CGFloat { 547 }
    override var dismissYPosition: CGFloat { 300 }
    
    var setDateType = SetDateType.deadline {
        didSet {
            setDatePicker()
            show()
        }
    }
    
    private var deadlineDate = Date()
    private var startDate: Date?
    private var endDate: Date?
    
    /// 어떤 날짜를 설정하는지, 무슨 날짜로 결정했는지를 전달.
    var completeButtonTapped: Observable<(type: String, date: Date)> {
        return completeButton.rx.tap
            .withUnretained(self)
            .map { owner, _ in
                owner.hide()
                
                switch owner.setDateType {
                case .deadline: return ("deadline", owner.deadlineDate)
                case .start: return ("start", owner.startDate ?? Date())
                case .end: return ("end", owner.endDate ?? Date())
                }
            }
    }
    
    // MARK: - Layout
    override func configureLayouts() {
        super.configureLayouts()
        
        rootFlexContainer.flex.define { flex in
            flex.addItem(dragHandleBar).alignSelf(.center).width(27).height(5).marginTop(10)
            
            flex.addItem(titleLabel).width(150).height(22).marginTop(30).marginLeft(16)
            
            flex.addItem().backgroundColor(BridgeColor.gray8).height(1).marginTop(8)
            
            flex.addItem(datePicker).marginTop(40).marginHorizontal(16)
           
            flex.addItem().grow(1)
            flex.addItem(completeButton).height(52).marginHorizontal(16).marginBottom(34)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    // MARK: - Bind
    override func bind() {
        datePicker.rx.date.changed
            .withUnretained(self)
            .subscribe(onNext: { owner, date in
                switch owner.setDateType {
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
        
        switch setDateType {
        case .deadline:
            titleLabel.text = "모집 마감일"
            datePicker.minimumDate = nil  // 초기화
            datePicker.maximumDate = maximumDate
            datePicker.date = deadlineDate
            
            
        case .start:
            titleLabel.text = "시작일"
            datePicker.minimumDate = nil
            datePicker.maximumDate = endDate ?? maximumDate  // endDate가 존재하지 않는다면, 최대 1년으로 설정.
            datePicker.date = startDate ?? Date()
            
            
        case .end:
            titleLabel.text = "예상 완료일"
            datePicker.minimumDate = startDate
            datePicker.maximumDate = maximumDate
            datePicker.date = endDate ?? Date()
        }
    }
}
