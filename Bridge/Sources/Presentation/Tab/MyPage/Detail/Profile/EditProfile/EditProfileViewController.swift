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
        navigationItem.title = "프로필 편집"
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: completeButton)
    }
    
    // MARK: - Layout
    override func configureLayouts() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentContainer)
        
        contentContainer.flex.define { flex in
            flex.addItem().direction(.row).justifyContent(.center).alignItems(.center).marginTop(52).define { flex in
                flex.addItem(profileImageView)
                flex.addItem(addProfileImageButton).marginTop(64).marginLeft(-22)
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
        let input = EditProfileViewModel.Input(
            
        )
        let output = viewModel.transform(input: input)
        
    }
}
