//
//  CompletionViewController.swift
//  Bridge
//
//  Created by 엄지호 on 2023/09/11.
//

import UIKit
import FlexLayout
import PinLayout
import RxCocoa
import RxSwift

final class CompletionViewController: BaseViewController {
    // MARK: - UI
    private let rootFlexContainer = UIView()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.configureTextWithLineHeight(
            text: "모집글 작성 완료!\n좋은 팀원들을 만날거예요!",
            lineHeight: 30,
            alignment: .center
        )
        label.font = BridgeFont.headline1Long.font
        label.textColor = BridgeColor.gray01
        label.numberOfLines = 2
        
        return label
    }()
    
    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "관리페이지에서 수정할 수 있어요"
        label.font = BridgeFont.body2Long.font
        label.textColor = BridgeColor.gray04
        
        return label
    }()
    
    private let castleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "blockcastle")
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private let completeButton: BridgeButton = {
        let button = BridgeButton(
            title: "완료",
            font: BridgeFont.button1.font,
            backgroundColor: BridgeColor.gray04
        )
        button.isEnabled = true
        
        return button
    }()
    
    // MARK: - Property
    private let viewModel: CompletionViewModel
    
    // MARK: - Init
    init(viewModel: CompletionViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Configuration
    override func configureAttributes() {
        navigationItem.title = "모집글 작성"
    }
    
    // MARK: - Layout
    override func configureLayouts() {
        view.addSubview(rootFlexContainer)
        
        rootFlexContainer.flex.alignItems(.center).define { flex in
            flex.addItem(titleLabel).width(210).height(60).marginTop(56)
            flex.addItem(subTitleLabel).width(180).height(20).marginTop(8)
            flex.addItem(castleImageView).size(200).marginTop(114)
            flex.addItem().grow(1)
            flex.addItem(completeButton).alignSelf(.stretch).height(52).marginHorizontal(16).marginBottom(24)
        }
    }
    
    override func viewDidLayoutSubviews() {
        rootFlexContainer.pin.all(view.pin.safeArea)
        rootFlexContainer.flex.layout()
    }
    
    // MARK: - Binding
    override func bind() {
        let input = CompletionViewModel.Input(
            completeButtonTapped: completeButton.rx.tap
        )
        let _ = viewModel.transform(input: input)
    }
}
