//
//  BaseCollectionReusableView.swift
//  Bridge
//
//  Created by 엄지호 on 2023/09/03.
//

import UIKit
import RxSwift

class BaseCollectionReusableView: UICollectionReusableView {
    // MARK: - Property
    var disposeBag = DisposeBag()
    
    // MARK: - Init
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
    
    // MARK: - Configurations
    func configureAttributes() {

    }
    
    func configureLayouts() {
        
    }
    
    func bind() {
        
    }
}
