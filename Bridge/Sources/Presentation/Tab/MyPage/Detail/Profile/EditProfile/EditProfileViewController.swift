//
//  EditProfileViewController.swift
//  Bridge
//
//  Created by 엄지호 on 1/1/24.
//

import UIKit
import FlexLayout
import PinLayout
import RxCocoa
import RxSwift

final class EditProfileViewController: BaseViewController {
    // MARK: - UI
    private let completeButton: UIButton = {
        let button = UIButton()
        button.setTitle("완료", for: .normal)
        button.setTitleColor(BridgeColor.primary1, for: .normal)
        button.titleLabel?.font = BridgeFont.body2.font
        return button
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private let contentContainer = UIView()
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.flex.size(92)
        imageView.image = UIImage(named: "profile.medium")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let addProfileImageButton: UIButton = {
        let button = UIButton()
        button.flex.size(28).cornerRadius(14)
        button.setImage(
            UIImage(named: "camera")?.resize(to: CGSize(width: 18, height: 18)).withRenderingMode(.alwaysTemplate),
            for: .normal
        )
        button.backgroundColor = BridgeColor.gray04
        button.tintColor = BridgeColor.gray10
        return button
    }()
    
    private let nameTitleLabel: UILabel = {
        let label = UILabel()
        label.flex.width(28).height(24)
        label.text = "이름"
        label.textColor = BridgeColor.gray01
        label.font = BridgeFont.subtitle2.font
        return label
    }()
    
    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.flex.height(52)
        textField.attributedPlaceholder = NSAttributedString(
            string: "이름을 입력해주세요.",
            attributes: [.foregroundColor: BridgeColor.gray04]
        )
        textField.font = BridgeFont.body2.font
        textField.textColor = BridgeColor.gray02
        textField.layer.borderWidth = 1
        textField.layer.borderColor = BridgeColor.gray06.cgColor
        textField.layer.cornerRadius = 8
        textField.clipsToBounds = true
        textField.addLeftPadding(with: 16)
        
        return textField
    }()
    
    private let carrerTitleLabel: UILabel = {
        let label = UILabel()
        label.flex.width(56).height(24)
        label.text = "경력사항"
        label.textColor = BridgeColor.gray01
        label.font = BridgeFont.subtitle2.font
        return label
    }()
    
    private let studentButton = BridgeFieldTagButton("학생")
    private let jobSeekerButton = BridgeFieldTagButton("취준생")
    private let currentEmployeeButton = BridgeFieldTagButton("현직자")
    
    private let introductionTitleLabel: UILabel = {
        let label = UILabel()
        label.flex.width(56).height(22)
        label.text = "자기소개"
        label.textColor = BridgeColor.gray01
        label.font = BridgeFont.subtitle2.font
        return label
    }()
    
    private let introductionTextView: BridgeTextView = {
        let textView = BridgeTextView(textViewPlaceholder: "팀원들에게 나를 소개해보세요.", maxCount: 300)
        textView.flex.height(106)
        return textView
    }()
    
    // MARK: - Property
    private let viewModel: EditProfileViewModel
    
    // MARK: - Init
    init(viewModel: EditProfileViewModel) {
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
        navigationItem.title = "프로필 편집"
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: completeButton)
    }
    
    // MARK: - Layout
    override func configureLayouts() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentContainer)
        
        contentContainer.flex.paddingHorizontal(16).define { flex in
            flex.addItem().direction(.row).justifyContent(.center).alignItems(.center).marginTop(52).define { flex in
                flex.addItem(profileImageView)
                flex.addItem(addProfileImageButton).marginTop(64).marginLeft(-22)
            }
            
            flex.addItem(nameTitleLabel).marginTop(48)
            flex.addItem(nameTextField).marginTop(14)
            
            flex.addItem(carrerTitleLabel).marginTop(24)
            flex.addItem().direction(.row).marginTop(14).define { flex in
                flex.addItem(studentButton)
                flex.addItem(jobSeekerButton).marginLeft(12)
                flex.addItem(currentEmployeeButton).marginLeft(12)
            }
            
            flex.addItem(introductionTitleLabel).marginTop(24)
            flex.addItem(introductionTextView).marginTop(14)
            
            flex.addItem().backgroundColor(BridgeColor.gray09).height(8).marginTop(24).marginHorizontal(-16)
            
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
        let input = EditProfileViewModel.Input(
            
        )
        let output = viewModel.transform(input: input)
    }
}
