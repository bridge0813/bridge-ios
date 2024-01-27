//
//  BaseProfileEditorViewController.swift
//  Bridge
//
//  Created by 엄지호 on 1/11/24.
//

import UIKit
import PhotosUI
import FlexLayout
import PinLayout
import RxCocoa
import RxSwift

/// 프로필 작성을 위한 BaseViewController('프로필 수정'과 '프로필 등록' 에서 사용)
class BaseProfileEditorViewController: BaseViewController {
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
        imageView.flex.size(92).cornerRadius(92 / 2)
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
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
    private let imagePicker: PHPickerViewController = {
        var config = PHPickerConfiguration()
        config.filter = .images
        let imagePicker = PHPickerViewController(configuration: config)
        return imagePicker
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
    
    private let careerTitleLabel: UILabel = {
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
        let textView = BridgeTextView(
            placeholder: "팀원들에게 나를 소개해보세요.",
            maxCount: 300,
            textColor: BridgeColor.gray02
        )
        textView.flex.height(106)
        return textView
    }()
    
    private let techStackTitleLabel: UILabel = {
        let label = UILabel()
        label.flex.width(28).height(24)
        label.text = "스택"
        label.textColor = BridgeColor.gray01
        label.font = BridgeFont.subtitle2.font
        return label
    }()
    
    private let addTechStackButton = BridgeAddButton(titleFont: BridgeFont.body3.font)
    private let editTechStackListView = EditProfileTechStackListView()
    private let fieldTechStackPickerView = FieldTechStackPickerPopUpView()
    
    private let linkTitleLabel: UILabel = {
        let label = UILabel()
        label.flex.width(60).height(24)
        label.text = "참고 링크"
        label.textColor = BridgeColor.gray01
        label.font = BridgeFont.subtitle2.font
        return label
    }()
    private let addLinkButton = BridgeAddButton(titleFont: BridgeFont.body3.font)
    private let linkListView = ProfileLinkListView(isDeletable: true)
    private let addLinkPopUpView = AddLinkPopUpView()
    
    private let fileTitleLabel: UILabel = {
        let label = UILabel()
        label.flex.width(100).height(24)
        label.text = "첨부파일(PDF)"
        label.textColor = BridgeColor.gray01
        label.font = BridgeFont.subtitle2.font
        return label
    }()
    private let addFileButton = BridgeAddButton(titleFont: BridgeFont.body3.font)
    private let fileListView = ProfileFileListView(isDeletable: true)
    private let documentPicker: UIDocumentPickerViewController = {
        let documentTypes = [UTType.pdf]
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: documentTypes)
        return documentPicker
    }()
    
    // MARK: - Lifecycle
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
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: completeButton)
        enableKeyboardHiding(shouldCancelTouchesInView: false)
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
            
            flex.addItem(careerTitleLabel).marginTop(24)
            flex.addItem().direction(.row).marginTop(14).define { flex in
                flex.addItem(studentButton)
                flex.addItem(jobSeekerButton).marginLeft(12)
                flex.addItem(currentEmployeeButton).marginLeft(12)
            }
            
            flex.addItem(introductionTitleLabel).marginTop(24)
            flex.addItem(introductionTextView).marginTop(14)
            
            flex.addItem().backgroundColor(BridgeColor.gray09).height(8).marginTop(24).marginHorizontal(-16)
            
            flex.addItem()
                .direction(.row)
                .justifyContent(.spaceBetween)
                .alignItems(.center)
                .marginTop(24)
                .define { flex in
                    flex.addItem(techStackTitleLabel)
                    flex.addItem(addTechStackButton)
                }
            flex.addItem(editTechStackListView).marginTop(14)
            
            flex.addItem().backgroundColor(BridgeColor.gray09).height(8).marginTop(24).marginHorizontal(-16)
            
            flex.addItem()
                .direction(.row)
                .justifyContent(.spaceBetween)
                .alignItems(.center)
                .marginTop(24)
                .define { flex in
                    flex.addItem(linkTitleLabel)
                    flex.addItem(addLinkButton)
                }
            flex.addItem(linkListView).marginTop(14)
            
            flex.addItem()
                .direction(.row)
                .justifyContent(.spaceBetween)
                .alignItems(.center)
                .marginTop(24)
                .define { flex in
                    flex.addItem(fileTitleLabel)
                    flex.addItem(addFileButton)
                }
            flex.addItem(fileListView).marginTop(14)
            
            flex.addItem().height(50)
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
        // Show - 분야 및 스택 추가 뷰
        addTechStackButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.fieldTechStackPickerView.show()
            })
            .disposed(by: disposeBag)
        
        // Show - 링크 추가 뷰
        addLinkButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.addLinkPopUpView.show()
            })
            .disposed(by: disposeBag)
        
        // Show - 파일 추가 뷰
        addFileButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.present(owner.documentPicker, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        
        // Show - 이미지 추가 뷰
        addProfileImageButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.present(owner.imagePicker, animated: true)
            })
            .disposed(by: disposeBag)
    }
}

extension BaseProfileEditorViewController {
    func configure(with profile: Profile) {
        // 유저가 선택(수정)한 이미지가 있다면 설정
        if let profileImage = profile.updatedImage {
            profileImageView.image = profileImage
        } else {
            profileImageView.setImage(
                with: profile.imageURL,
                size: CGSize(width: 92, height: 92),
                placeholderImage: UIImage(named: "profile.medium")
            )
        }
        
        // 이름 설정
        nameTextField.text = profile.name
        
        // 직업 설정
        if let career = profile.career {
            // 선택해제
            let careerButtons = [studentButton, jobSeekerButton, currentEmployeeButton]
            careerButtons.forEach { $0.isSelected = false }
            
            switch career {
            case "학생": studentButton.isSelected = true
            case "취준생": jobSeekerButton.isSelected = true
            case "현직자": currentEmployeeButton.isSelected = true
            default: print("Error")
            }
        }
        
        // 자기소개 설정
        if let introduction = profile.introduction {
            introductionTextView.text = introduction
        }
        
        // 기술스택 설정
        editTechStackListView.fieldTechStacks = profile.fieldTechStacks
        editTechStackListView.flex.markDirty()
        
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

// MARK: - Observable
extension BaseProfileEditorViewController {
    /// 이미지 추가
    var addedProfileImage: Observable<UIImage?> {
        return imagePicker.rx.didFinishPicking
    }
    
    /// 이름 변경
    var nameChanged: Observable<String> {
        return nameTextField.rx.controlEvent(.editingDidEnd)
            .withLatestFrom(nameTextField.rx.text.orEmpty)
            .distinctUntilChanged()
    }
    
    /// 직업 선택
    var careerButtonTapped: Observable<String> {
        Observable.merge(
            studentButton.rx.tap.map { "학생" },
            jobSeekerButton.rx.tap.map { "취준생" },
            currentEmployeeButton.rx.tap.map { "현직자" }
        )
    }
    
    /// 소개 변경
    var introductionChanged: Observable<String> {
        return introductionTextView.resultText
    }
    
    /// 기술스택 추가
    var addedFieldTechStack: Observable<FieldTechStack> {
        return fieldTechStackPickerView.selectedFieldTechStack
    }
    
    /// 기술스택 삭제
    var deletedFieldTechStack: Observable<IndexRow> {
        return editTechStackListView.deletedFieldTechStack
    }
    
    /// 기술스택 수정
    var updatedFieldTechStack: Observable<(IndexRow, FieldTechStack)> {
        return editTechStackListView.updatedFieldTechStack
    }
    
    /// 링크 추가
    var addedLinkURL: Observable<String> {
        return addLinkPopUpView.addedLinkURL
    }
    
    /// 링크 삭제
    var deletedLinkURL: Observable<IndexRow> {
        return linkListView.deletedLinkURL
    }
    
    /// 파일 추가
    var addedFile: Observable<Result<ReferenceFile, FileProcessingError>> {
        return documentPicker.rx.didFinishPicking
    }
    
    /// 파일 삭제
    var deletedFile: Observable<IndexRow> {
        return fileListView.deletedFile
    }
    
    /// 완료 버튼 탭
    var completeButtonTapped: Observable<Void> {
        return completeButton.rx.tap.asObservable()
    }
}
