//
//  BaseButton.swift
//  Bridge
//
//  Created by 엄지호 on 2023/09/26.
//

import UIKit
import RxSwift

class BaseButton: UIButton {
    
    var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureAttributes()
        configureLayouts()
        bind()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 기타 속성들을 설정하기 위한 메서드
    func configureAttributes() {
        // 예: 기본 텍스트 색상, 폰트 등의 속성 설정
    }
    
    /// 기타 속성들을 설정하기 위한 메서드(타이틀이 유연하게 변경되어야 하는 버튼을 위함)
    func configureAttributes(with title: String) {
        
    }
    
    /// UI와 관련된 속성들(버튼의 이미지, 배경색 등)을 설정하기 위한 메서드
    func configureLayouts() {
        // 예: 패딩, 마진, 버튼의 내부 이미지나 텍스트의 위치 조정 등
    }
    
    /// 버튼에 대한 Rx 이벤트 바인딩 등을 처리하기 위한 메서드
    func bind() { }
}
