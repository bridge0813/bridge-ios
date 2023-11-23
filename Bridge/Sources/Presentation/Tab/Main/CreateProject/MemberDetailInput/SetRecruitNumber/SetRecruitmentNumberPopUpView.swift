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
final class SetRecruitmentNumberPopUpView: BridgeBasePopUpView {
    // MARK: - UI
    private lazy var pickerView: UIPickerView = {
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        
        return picker
    }()
    
    // MARK: - Property
    override var containerHeight: CGFloat { 409 }
    override var dismissYPosition: CGFloat { 250 }
    
    var completeButtonTapped: Observable<Int> {
        return completeButton.rx.tap
            .withUnretained(self)
            .map { owner, _ in
                owner.hide()
                let selectedRow = owner.pickerView.selectedRow(inComponent: 0)
                return selectedRow + 1
            }
            .distinctUntilChanged()
            .share()
    }
    
    // MARK: - Configuration
    override func configureAttributes() {
        super.configureAttributes()
        titleLabel.text = "모집 인원"
    }
    
    // MARK: - Layout
    override func configureLayouts() {
        super.configureLayouts()
        
        rootFlexContainer.flex.define { flex in
            flex.addItem(dragHandleBar).alignSelf(.center).marginTop(10)
            
            flex.addItem(titleLabel).width(67).height(22).marginTop(30).marginLeft(16)
            
            flex.addItem().backgroundColor(BridgeColor.gray08).height(1).marginTop(7)
            
            flex.addItem(pickerView).height(120).marginTop(56)
            
            flex.addItem().grow(1)
            flex.addItem(completeButton).height(52).marginHorizontal(16).marginBottom(50)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }

    // MARK: - Bind
    override func bind() {
        pickerView.rx.itemSelected
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
        label.textColor = BridgeColor.gray01
        label.font = BridgeFont.headline1.font
        label.textAlignment = .center
        
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40
    }
}
