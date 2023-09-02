//
//  BaseViewController.swift
//  Bridge
//
//  Created by 정호윤 on 2023/08/29.
//

import UIKit
import RxSwift

class BaseViewController: UIViewController {
    
    var disposeBag = DisposeBag()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 기타 속성(데이터 소스, 네비게이션 바 등)들을 설정하기 위한 메서드
    func configureAttributes() { }
    
    /// UI와 관련된 속성들(뷰 계층, 레이아웃 등)을 설정하기 위한 메서드
    func configureLayouts() { }
    
    /// 뷰 모델과 뷰를 바인딩하기 위한 메서드
    func bind() { }
}

// MARK: - Life cycles
extension BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        configureAttributes()
        configureLayouts()
        bind()
    }
}
