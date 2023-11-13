//
//  ProjectDetailViewController.swift
//  Bridge
//
//  Created by 엄지호 on 2023/11/10.
//

import UIKit
import FlexLayout
import PinLayout
import RxCocoa
import RxSwift

/// 모집글 상세뷰
final class ProjectDetailViewController: BaseViewController {
    // MARK: - UI
    private let rootFlexContainer = UIView()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .clear
        scrollView.showsVerticalScrollIndicator = false
        
        return scrollView
    }()
    
    private let contentContainer: UIView = {
        let view = UIView()
        view.backgroundColor = BridgeColor.gray09
        
        return view
    }()
    
    private let dividerView: UIView = {
        let divider = UIView()
        divider.backgroundColor = BridgeColor.gray06
        divider.isHidden = true
        
        return divider
    }()
    
    private let firstSectionView = FirstSectionView()
    private let secondSectionView = SecondSectionView()
    private let thirdSectionView = ThirdSectionView()

    private let menuBar = MenuBar()
    
    // MARK: - Property
    private let viewModel: ProjectDetailViewModel
    
    // MARK: - Init
    init(viewModel: ProjectDetailViewModel) {
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
        configureNavigationUI()
    }
    
    private func configureNavigationUI() {
        navigationItem.title = "프로젝트 상세"
    }
    
    // MARK: - Layout
    override func configureLayouts() {
        view.addSubview(rootFlexContainer)
        scrollView.addSubview(contentContainer)
        
        rootFlexContainer.flex.define { flex in
            flex.addItem(dividerView).height(1)
            flex.addItem().grow(1)
            
            flex.addItem(scrollView).position(.absolute).width(100%).top(1).bottom(102)
            flex.addItem(menuBar)
        }
        
        contentContainer.flex.define { flex in
            flex.addItem(firstSectionView)
            flex.addItem(secondSectionView).marginTop(8)
            flex.addItem(thirdSectionView).marginTop(8)
        }
    }
    
    override func viewDidLayoutSubviews() {
        rootFlexContainer.pin.top(view.pin.safeArea.top).left().bottom().right()
        rootFlexContainer.flex.layout()
        
        contentContainer.pin.all()
        contentContainer.flex.layout(mode: .adjustHeight)
        scrollView.contentSize = CGSize(width: scrollView.frame.width, height: contentContainer.frame.height)
    }
    
    // MARK: - Binding
    override func bind() {
        let input = ProjectDetailViewModel.Input(
            viewDidLoad: .just(()),
            goToDetailButtonTapped: thirdSectionView.goToDetailButtonTapped
        )
        let output = viewModel.transform(input: input)
        
        output.project
            .drive(onNext: { [weak self] data in
                guard let self else { return }
                
                self.firstSectionView.configureContents(with: data)
                self.secondSectionView.configureContents(with: data)
                self.thirdSectionView.configureContents(with: data.memberRequirements)
            })
            .disposed(by: disposeBag)
        
        // 구분선 등장
        scrollView.rx.contentOffset
            .map { $0.y > 0 }
            .distinctUntilChanged()
            .withUnretained(self)
            .subscribe(onNext: { owner, shouldHidden in
                owner.dividerView.isHidden = !shouldHidden
            })
            .disposed(by: disposeBag)
    }
}
