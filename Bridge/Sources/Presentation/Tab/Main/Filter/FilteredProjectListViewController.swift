//
//  FilteredProjectListViewController.swift
//  Bridge
//
//  Created by 엄지호 on 2/4/24.
//

import UIKit
import FlexLayout
import PinLayout
import RxCocoa
import RxSwift

final class FilteredProjectListViewController: BaseViewController {
    // MARK: - UI
    private let rootFlexContainer = UIView()
    
    private lazy var searchButton = UIBarButtonItem(
        image: UIImage(named: "magnifyingglass")?
            .resize(to: CGSize(width: 24, height: 24))
            .withRenderingMode(.alwaysTemplate),
        style: .plain,
        target: self,
        action: nil
    )
    
    // MARK: - Property
    private let viewModel: FilteredProjectListViewModel
    
    // MARK: - Init
    init(viewModel: FilteredProjectListViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNoShadowNavigationBarAppearance()
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        configureDefaultNavigationBarAppearance()
        tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: - Configuration
    override func configureAttributes() {
        navigationItem.rightBarButtonItem = searchButton
    }
    
    // MARK: - Layout
    override func configureLayouts() {
        view.addSubview(rootFlexContainer)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        rootFlexContainer.pin.all(view.pin.safeArea)
        rootFlexContainer.flex.layout()
    }
    
    // MARK: - Binding
    override func bind() {
        let input = FilteredProjectListViewModel.Input(
            viewWillAppear: self.rx.viewWillAppear.asObservable()
        )
        let output = viewModel.transform(input: input)
        
        output.fieldTechStack
            .drive(onNext: { [weak self] fieldTechStack in
                guard let self else { return }
                self.navigationItem.title = self.configureNavigationTitle(from: fieldTechStack.field)
            })
            .disposed(by: disposeBag)
    }
}

extension FilteredProjectListViewController {
    private func configureNavigationTitle(from field: String) -> String {
        switch field {
        case "iOS": return "iOS 개발자"
        case "안드로이드": return "안드로이드 개발자"
        case "프론트엔드": return "프론트엔드 개발자"
        case "백엔드": return "백엔드 개발자"
        case "UI/UX": return "UI/UX 디자이너"
        case "BI/BX": return "BI/BX 디자이너"
        case "영상/모션": return "영상/모션 디자이너"
        case "PM": return "기획자"
        default: return "Error"
        }
    }
}
