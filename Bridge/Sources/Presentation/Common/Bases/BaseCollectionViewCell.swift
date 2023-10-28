//
//  BaseCollectionViewCell.swift
//  Bridge
//
//  Created by 엄지호 on 2023/08/31.
//

import UIKit
import RxSwift

class BaseCollectionViewCell: UICollectionViewCell {
    
    var disposeBag = DisposeBag()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        configureAttributes()
        configureLayouts()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 기타 속성들을 설정하기 위한 메서드
    func configureAttributes() { }
    
    /// UI와 관련된 속성들(뷰 계층, 레이아웃 등)을 설정하기 위한 메서드
    func configureLayouts() { }
    
    /// 바인딩을 위한 메서드
    func bind() { }
}
