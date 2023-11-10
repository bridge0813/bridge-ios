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
        view.backgroundColor = BridgeColor.gray9
        
        return view
    }()
    
    private let firstSectionView = FirstSectionView()
    private let secondSectionView = SecondSectionView()
    private let thirdSectionView = ThirdSectionView()

    private let menuBar: UIView = {
        let view = UIView()
        view.backgroundColor = BridgeColor.gray10
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.04
        view.layer.shadowOffset = CGSize(width: 0, height: -6)
        view.layer.shadowRadius = 10.0
        
        return view
    }()
    private let bookmarkButton = BridgeBookmarkButton()
    private let applyButton: BridgeButton = {
        let button = BridgeButton(
            title: "지원하기",
            font: BridgeFont.button1.font,
            backgroundColor: BridgeColor.gray4
        )
        button.isEnabled = true
        
        return button
    }()
    
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
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
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
            flex.addItem(scrollView).grow(1)
            flex.addItem(menuBar)
                .position(.absolute)
                .direction(.row)
                .width(100%)
                .height(102)
                .padding(16)
                .bottom(0)
                .define { flex in
                    flex.addItem(bookmarkButton).width(54).height(52).marginTop(15)
                    flex.addItem(applyButton).grow(1).height(52).marginTop(15).marginLeft(12)
                }
        }
        
        contentContainer.flex.define { flex in
            flex.addItem(firstSectionView)
            flex.addItem(secondSectionView).marginTop(8)
            flex.addItem(thirdSectionView).marginTop(8)
        }
    }
    
    override func viewDidLayoutSubviews() {
        rootFlexContainer.pin.all(view.pin.safeArea)
        rootFlexContainer.flex.layout()
        
        contentContainer.pin.all()
        contentContainer.flex.layout(mode: .adjustHeight)
        scrollView.contentSize = CGSize(width: scrollView.frame.width, height: contentContainer.frame.height + 102)
        
        let shadowPath = UIBezierPath(rect: menuBar.bounds)
        menuBar.layer.shadowPath = shadowPath.cgPath
    }
    
    // MARK: - Binding
    override func bind() {
        let input = ProjectDetailViewModel.Input(
            viewWillAppear: self.rx.viewWillAppear.asObservable()
        )
        let output = viewModel.transform(input: input)
       
    }
}
