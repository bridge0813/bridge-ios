//
//  BaseLabel.swift
//  Bridge
//
//  Created by 엄지호 on 2023/11/10.
//

import UIKit

class BaseLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureAttributes()
        configureLayouts()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 기타 속성들을 설정하기 위한 메서드
    func configureAttributes() {
        // 예: 기본 텍스트 색상, 폰트 등의 속성 설정
    }
    
    /// UI와 관련된 속성들(버튼의 이미지, 배경색 등)을 설정하기 위한 메서드
    func configureLayouts() {
        // 예: 패딩, 마진, 버튼의 내부 이미지나 텍스트의 위치 조정 등
    }
}
