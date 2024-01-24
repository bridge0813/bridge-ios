//
//  ProfileViewController.swift
//  Bridge
//
//  Created by 정호윤 on 12/14/23.
//

import UIKit
import FlexLayout
import PinLayout
import RxCocoa
import RxSwift

final class ProfileViewController: BaseViewController {
    // MARK: - UI
    private let editProfileButton: UIButton = {
        let button = UIButton()
        button.setTitle("수정", for: .normal)
        button.setTitleColor(BridgeColor.gray01, for: .normal)
        button.titleLabel?.font = BridgeFont.body2.font
        
        return button
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.bounces = false
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private let contentContainer: UIView = {
        let view = UIView()
        view.backgroundColor = BridgeColor.primary3
        return view
    }()
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.flex.width(155).height(153).cornerRadius(20)
        imageView.tintColor = BridgeColor.gray04
        imageView.backgroundColor = BridgeColor.gray10
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.flex.width(150).height(24)
        label.font = BridgeFont.headline1.font
        return label
    }()
    
    private let careerLabel: BridgeFilledChip = {
        let label = BridgeFilledChip(
            backgroundColor: BridgeColor.primary2,
            type: .custom(padding: .init(top: 8, left: 14, bottom: 8, right: 14), radius: 15)
        )
        label.textColor = BridgeColor.primary1
        return label
    }()
    
    private let fieldsLabel: UILabel = {
        let label = UILabel()
        label.textColor = BridgeColor.primary1
        label.font = BridgeFont.body2.font
        return label
    }()
    
    /// 배경이 white 컬러인 컨테이너(자기소개, 스택 등의 컨텐츠를 보여주고 있음).
    private let whiteContainer: UIView = {
        let view = UIView()
        view.backgroundColor = BridgeColor.gray10
        view.clipsToBounds = true
        view.layer.cornerRadius = 12
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return view
    }()
    
    private let introductionTitleLabel: UILabel = {
        let label = UILabel()
        label.flex.width(56).height(22)
        label.text = "자기소개"
        label.textColor = BridgeColor.gray01
        label.font = BridgeFont.subtitle2.font
        return label
    }()
    
    private let introductionLabelContainer: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1
        view.layer.borderColor = BridgeColor.gray06.cgColor
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        return view
    }()
    
    private let introductionLabel: UILabel = {
        let label = UILabel()
        label.font = BridgeFont.body2.font
        label.numberOfLines = 0
        return label
    }()
    
    private let techStackTitleLabel: UILabel = {
        let label = UILabel()
        label.flex.width(28).height(24)
        label.text = "스택"
        label.textColor = BridgeColor.gray01
        label.font = BridgeFont.subtitle2.font
        return label
    }()
    
    private let techStackView = ProfileTechStackListView()
    
    private let linkTitleLabel: UILabel = {
        let label = UILabel()
        label.flex.width(60).height(24)
        label.text = "참고 링크"
        label.textColor = BridgeColor.gray01
        label.font = BridgeFont.subtitle2.font
        return label
    }()
    private let linkListView = ProfileLinkListView(isDeletable: false)
    
    private let fileTitleLabel: UILabel = {
        let label = UILabel()
        label.flex.width(56).height(24)
        label.text = "첨부파일"
        label.textColor = BridgeColor.gray01
        label.font = BridgeFont.subtitle2.font
        return label
    }()
    private let fileListView = ProfileFileListView(isDeletable: false)
    private let pdfView = PDFPopUpView()
    
    // MARK: - Property
    private let viewModel: ProfileViewModel
    
    // MARK: - Init
    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    // MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNoShadowNavigationBarAppearance(with: BridgeColor.primary3)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        configureDefaultNavigationBarAppearance()
        tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: - Configuration
    override func configureAttributes() {
        navigationItem.title = "프로필"
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: editProfileButton)
    }
    
    // MARK: - Layout
    override func configureLayouts() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentContainer)
        
        contentContainer.flex.define { flex in
            flex.addItem(profileImageView).alignSelf(.center).marginTop(52)
            flex.addItem(nameLabel).marginTop(38).marginLeft(16)
            flex.addItem().direction(.row).alignItems(.center).marginTop(12).marginHorizontal(16).define { flex in
                flex.addItem(careerLabel).marginRight(12)
                flex.addItem(fieldsLabel)
            }
            
            flex.addItem(whiteContainer).marginTop(20).paddingHorizontal(16).define { flex in
                flex.addItem(introductionTitleLabel).marginTop(40)
                flex.addItem(introductionLabelContainer).padding(17, 16, 17, 16).marginTop(14).define { flex in
                    flex.addItem(introductionLabel)
                }
                
                flex.addItem(techStackTitleLabel).marginTop(14)
                flex.addItem(techStackView).marginTop(14)
                
                flex.addItem(linkTitleLabel).marginTop(24)
                flex.addItem(linkListView).marginTop(14)
                
                flex.addItem(fileTitleLabel).marginTop(24)
                flex.addItem(fileListView).marginTop(14)
                
                flex.addItem().height(50)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.pin.all(view.pin.safeArea)
        contentContainer.pin.top().horizontally()
        contentContainer.flex.layout(mode: .adjustHeight)
        
        scrollView.contentSize = contentContainer.frame.size
    }
    
    // MARK: - Binding
    override func bind() {
        let input = ProfileViewModel.Input(
            viewWillAppear: self.rx.viewWillAppear.asObservable(),
            editProfileButtonTapped: editProfileButton.rx.tap,
            selectedLinkURL: linkListView.selectedLinkURL,
            selectedFile: fileListView.selectedFile
        )
        let output = viewModel.transform(input: input)
        
        // 프로필 정보
        output.profile
            .drive(onNext: { [weak self] profile in
                guard let self else { return }
                self.configure(with: profile)
            })
            .disposed(by: disposeBag)
        
        // 파일 보여주기
        output.downloadedFile
            .withUnretained(self)
            .subscribe(onNext: { owner, url in
                owner.pdfView.url = url
                owner.pdfView.show()
            })
            .disposed(by: disposeBag)
        
        // 스크롤에 따른 NavigationBar Color 수정
        scrollView.rx.contentOffset
            .withUnretained(self)
            .subscribe(onNext: { owner, offset in
                if offset.y > 0 { owner.configureDefaultNavigationBarAppearance(with: BridgeColor.gray10)
                } else { owner.configureNoShadowNavigationBarAppearance(with: BridgeColor.primary3) }
            })
            .disposed(by: disposeBag)
    }
}

extension ProfileViewController {
    private func configure(with profile: Profile) {
        // 프로필 이미지 설정
        profileImageView.setImage(with: profile.imageURL, size: CGSize(width: 155, height: 153))
        
        // 이름 설정
        nameLabel.text = "\(profile.name) 님"
        
        // 직업 설정
        if let career = profile.career {
            careerLabel.text = career
            careerLabel.text = "취준생"
            careerLabel.flex.display(.flex).width(careerLabel.intrinsicContentSize.width).height(30)
        } else {
            careerLabel.flex.display(.none)
        }
        
        // 분야 설정(관심분야와 다른 유저의 스택 분야)
        fieldsLabel.text = profile.fieldTechStacks.map { $0.field }.joined(separator: ", ")
        
        // 자기소개 설정
        if let introduction = profile.introduction {
            introductionLabel.configureTextWithLineHeight(
                text: introduction,
                lineHeight: 20
            )
            introductionLabel.textColor = BridgeColor.gray01
        } else {
            introductionLabel.text = "나를 소개해보세요."
            introductionLabel.textColor = BridgeColor.gray04
        }
        
        introductionLabel.flex.markDirty()
        
        // 기술스택 설정
        techStackView.fieldTechStacks = profile.fieldTechStacks
        techStackView.flex.markDirty()
        
        // 참고링크 설정
        linkListView.links = profile.links
        linkListView.flex.markDirty()
        
        // 첨부파일 설정
        fileListView.files = profile.files
        fileListView.flex.markDirty()
        
        contentContainer.flex.markDirty()
        view.setNeedsLayout()
    }
}
