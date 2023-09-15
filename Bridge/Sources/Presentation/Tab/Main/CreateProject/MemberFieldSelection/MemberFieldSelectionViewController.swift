//
//  MemberFieldSelectionViewController.swift
//  Bridge
//
//  Created by 엄지호 on 2023/09/11.
//

import UIKit
import FlexLayout
import PinLayout
import RxCocoa
import RxSwift

final class MemberFieldSelectionViewController: BaseViewController {
    // MARK: - Properties
    private let rootFlexContainer = UIView()
    private let instructionLabel: UILabel = {
        let label = UILabel()
        label.configureLabel(
            textColor: .black,
            font: .boldSystemFont(ofSize: 18),
            numberOfLines: 2
        )
        label.text = "어떤 분야의 팀원을 \n찾고 있나요?"
        
        return label
    }()
    
    private let iosButton = TagButton(title: "iOS")
    private let androidButton = TagButton(title: "안드로이드")
    private let frontEndButton = TagButton(title: "프론트엔드")
    private let backEndButton = TagButton(title: "백엔드")
    private let uiuxButton = TagButton(title: "UI/UX")
    private let bibxButton = TagButton(title: "BI/BX")
    private let videomotionButton = TagButton(title: "영상/모션")
    private let pmButton = TagButton(title: "PM")
    
    private let nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("다음", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.white, for: .highlighted)
        button.backgroundColor = .darkGray
        
        return button
    }()
    
    private let dismissButton: UIButton = {
        let button = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 23, weight: .regular, scale: .default)
        let buttonImage = UIImage(systemName: "xmark", withConfiguration: imageConfig)
        button.setImage(buttonImage, for: .normal)
        button.tintColor = .black
        
        return button
    }()

    private let viewModel: MemberFieldSelectionViewModel
    
    // MARK: - Initializer
    init(viewModel: MemberFieldSelectionViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configureNavigationUI()
    }
    
    override func viewDidLayoutSubviews() {
        rootFlexContainer.pin.all(view.pin.safeArea).marginTop(10)
        rootFlexContainer.flex.layout()
    }
    
    // MARK: - Methods
    private func configureNavigationUI() {
    }
    
    override func configureLayouts() {
        view.addSubview(rootFlexContainer)
        rootFlexContainer.flex.direction(.column).padding(5).define { flex in
            flex.addItem(dismissButton).position(.absolute).marginTop(25).marginLeft(10).size(25)
            
            flex.addItem(instructionLabel).width(200).height(50).marginTop(100).marginLeft(10)
            
            flex.addItem().direction(.column).marginTop(50).define { flex in
                flex.addItem().direction(.row).define { flex in
                    flex.addItem(iosButton).cornerRadius(8).marginLeft(10)
                    flex.addItem(androidButton).cornerRadius(8).marginLeft(10)
                }
                
                flex.addItem().direction(.row).marginTop(10).define { flex in
                    flex.addItem(frontEndButton).cornerRadius(8).marginLeft(10)
                    flex.addItem(backEndButton).cornerRadius(8).marginLeft(10)
                }
            }
            
            flex.addItem().direction(.column).marginTop(50).define { flex in
                flex.addItem().direction(.row).define { flex in
                    flex.addItem(uiuxButton).cornerRadius(8).marginLeft(10)
                    flex.addItem(bibxButton).cornerRadius(8).marginLeft(10)
                }
                
                flex.addItem().direction(.row).marginTop(10).define { flex in
                    flex.addItem(videomotionButton).cornerRadius(8).marginLeft(10)
                }
            }
            
            flex.addItem().direction(.row).marginTop(50).define { flex in
                flex.addItem(pmButton).cornerRadius(8).marginLeft(10)
            }
            
            flex.addItem().grow(1)
            
            flex.addItem().alignItems(.center).marginBottom(50).define { flex in
                flex.addItem(nextButton).width(280).height(50).cornerRadius(8)
            }
        }
    }
    
    override func configureAttributes() {
        configureNavigationUI()
    }
    
    override func bind() {
        let input = MemberFieldSelectionViewModel.Input(
            nextButtonTapped: nextButton.rx.tap.asObservable(),
            dismissButtonTapped: dismissButton.rx.tap.asObservable(),
            tagButtonTapped: mergeButtonTap()
        )
        let output = viewModel.transform(input: input)
        
        output.selectedTag
            .drive(onNext: { [weak self] type in
                self?.selectedButtonToggle(for: type)
            })
            .disposed(by: disposeBag)
    }
}

extension MemberFieldSelectionViewController {
    private func mergeButtonTap() -> Observable<MemberFieldSelectionViewModel.TagButtonType> {
        return Observable.merge(
            iosButton.rx.tap.map { MemberFieldSelectionViewModel.TagButtonType.iOS },
            androidButton.rx.tap.map { MemberFieldSelectionViewModel.TagButtonType.android },
            frontEndButton.rx.tap.map { MemberFieldSelectionViewModel.TagButtonType.frontEnd },
            backEndButton.rx.tap.map { MemberFieldSelectionViewModel.TagButtonType.backEnd },
            uiuxButton.rx.tap.map { MemberFieldSelectionViewModel.TagButtonType.uiux },
            bibxButton.rx.tap.map { MemberFieldSelectionViewModel.TagButtonType.bibx },
            videomotionButton.rx.tap.map { MemberFieldSelectionViewModel.TagButtonType.videomotion },
            pmButton.rx.tap.map { MemberFieldSelectionViewModel.TagButtonType.pm }
        )
    }
    
    private func selectedButtonToggle(for type: MemberFieldSelectionViewModel.TagButtonType) {
            switch type {
            case .iOS:
                iosButton.isSelected.toggle()
                
            case .android:
                androidButton.isSelected.toggle()
                
            case .frontEnd:
                frontEndButton.isSelected.toggle()
                
            case .backEnd:
                backEndButton.isSelected.toggle()
                
            case .uiux:
                uiuxButton.isSelected.toggle()
                
            case .bibx:
                bibxButton.isSelected.toggle()
                
            case .videomotion:
                videomotionButton.isSelected.toggle()
                
            case .pm:
                pmButton.isSelected.toggle()
            }
        }
}
