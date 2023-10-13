//
//  MainViewController.swift
//  Bridge
//
//  Created by 엄지호 on 2023/08/28.
//

import UIKit
import FlexLayout
import PinLayout
import RxCocoa
import RxSwift

final class MainViewController: BaseViewController {
    // MARK: - UI
    private let rootFlexContainer = UIView()
    
    private lazy var projectTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(MainProjectCell.self)
        tableView.backgroundColor = BridgeColor.gray9
        tableView.rowHeight = 170
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 24.2, left: 0, bottom: 0, right: 0)
        
        return tableView
    }()
    
    private let mainFieldCategoryAnchorButton = MainFieldCategoryAnchorButton()
    // TODO: - DataSource 동적으로 변경될 수 있도록 조정
    private lazy var mainFieldCategoryDropdown = DropDown(
        anchorView: mainFieldCategoryAnchorButton,
        bottomOffset: CGPoint(x: 10, y: 0),
        dataSource: ["UI/UX", "전체"],
        cellHeight: 46,
        itemTextColor: BridgeColor.gray3,
        itemTextFont: BridgeFont.body2.font,
        selectedItemTextColor: BridgeColor.gray1,
        dimmedBackgroundColor: .black.withAlphaComponent(0.3),
        width: 147,
        cornerRadius: 4
    )
    
    private let filterButton: UIButton = {
        let buttonImage = UIImage(named: "hamburger")?
            .resize(to: CGSize(width: 24, height: 24))
            
        let button = UIButton()
        button.setImage(buttonImage, for: .normal)
        return button
    }()
    
    private let searchButton: UIButton = {
        let buttonImage = UIImage(named: "magnifyingglass")?
            .resize(to: CGSize(width: 24, height: 24))
            
        let button = UIButton()
        button.setImage(buttonImage, for: .normal)
        return button
    }()

    private let mainCategoryHeaderView = MainCategoryHeaderView()
    
    private let createProjectButton = BrideCreateProjectButton()
    
    // MARK: - Properties
    private let viewModel: MainViewModel
    
    private typealias DataSource = UITableViewDiffableDataSource<MainViewModel.Section, Project>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<MainViewModel.Section, Project>
    private var dataSource: DataSource?
    
    
    // MARK: - Initializer
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        rootFlexContainer.pin.all(view.pin.safeArea)
        rootFlexContainer.flex.layout()
    }
    
    // MARK: - Configure
    private func configureNavigationUI() {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func configureLayouts() {
        view.addSubview(rootFlexContainer)
        
        rootFlexContainer.flex.direction(.column).define { flex in
            flex.addItem().direction(.row).alignItems(.center).define { flex in
                flex.addItem(mainFieldCategoryAnchorButton).marginLeft(5)
                flex.addItem().grow(1)
                flex.addItem(filterButton).size(24).marginRight(8)
                flex.addItem(searchButton).size(24).marginRight(15)
            }
            
            flex.addItem(mainCategoryHeaderView).height(102).marginHorizontal(5)
            
            flex.addItem(projectTableView).grow(1)
            
            flex.addItem(createProjectButton)
                .position(.absolute)
                .right(15)
                .bottom(15)
                .width(106)
                .height(48)
        }
    }
    
    override func configureAttributes() {
        dataSource = configureDataSource()
        configureNavigationUI()
    }
    
    // MARK: - Bind
    override func bind() {
        let input = MainViewModel.Input(
            viewWillAppear: self.rx.viewWillAppear.asObservable(),
            didScroll: projectTableView.rx.contentOffset.asObservable(),
            filterButtonTapped: filterButton.rx.tap.asObservable(),
            itemSelected: projectTableView.rx.itemSelected.asObservable(),
            createButtonTapped: createProjectButton.rx.tap.asObservable()
        )
        let output = viewModel.transform(input: input)
        
        output.projects
            .compactMap { [weak self] projects in
                self?.createCurrentSnapshot(with: projects)
            }
            .drive { [weak self] currentSnapshot in
                self?.dataSource?.apply(currentSnapshot)
            }
            .disposed(by: disposeBag)
        
        
        output.layoutMode
            .drive(onNext: { [weak self] mode in
                self?.animateLayoutChange(to: mode)
            })
            .disposed(by: disposeBag)
        
        mainFieldCategoryAnchorButton.rx.tap.asDriver()
            .drive(onNext: { [weak self] in
                self?.mainFieldCategoryDropdown.show()
            })
            .disposed(by: disposeBag)
        
        mainFieldCategoryDropdown.itemSelected
            .withUnretained(self)
            .subscribe(onNext: { owner, item in
                owner.mainFieldCategoryAnchorButton.updateTitle(item.title)
            })
            .disposed(by: disposeBag)
            
        mainCategoryHeaderView.categoryButtonTapped
            .withUnretained(self)
            .subscribe(onNext: { owner, type in
                owner.mainCategoryHeaderView.updateButtonState(type)
            })
            .disposed(by: disposeBag)
        
    }
}

// MARK: - Diffable data source
extension MainViewController {
    private func configureDataSource() -> DataSource {
        DataSource(tableView: projectTableView) { tableView, indexPath, item in
            guard let cell = tableView.dequeueReusableCell(MainProjectCell.self, for: indexPath) else {
                return UITableViewCell()
            }
            
            cell.selectionStyle = .none
            cell.contentView.isUserInteractionEnabled = false
            
            return cell
        }
    }
    
    private func createCurrentSnapshot(with projects: [Project]) -> Snapshot {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(projects)
        return snapshot
    }
}

// MARK: - CreateProjectButtonAnimation
extension MainViewController {
    private func animateLayoutChange(to mode: MainViewModel.CreateButtonDisplayState) {
        UIView.animate(
            withDuration: 0.2,
            animations: { [weak self] in
                self?.updateButtonConfiguration(for: mode)
                self?.updateButtonLayout(for: mode)
            },
            completion: { [weak self] _ in
                self?.updateButtonTitle(for: mode)
                self?.createProjectButton.contentHorizontalAlignment = .center
            }
        )
    }
    
    // MARK: - Button Layout
    private func updateButtonLayout(for state: MainViewModel.CreateButtonDisplayState) {
        let buttonWidth: CGFloat = state == .both ? 106 : 48
        
        createProjectButton.flex
            .position(.absolute)
            .cornerRadius(24)
            .width(buttonWidth)
            .height(48)
        
        rootFlexContainer.flex.layout()
    }
    
    // MARK: - Button Configuration
    private func updateButtonConfiguration(for state: MainViewModel.CreateButtonDisplayState) {
        switch state {
        case .both:
            createProjectButton.titleLabel?.alpha = 1
            updateButtonTitle(for: state)
            
        case .only:
            createProjectButton.titleLabel?.alpha = 0
            createProjectButton.contentHorizontalAlignment = .left
        }
    }
    
    // MARK: - Button Title
    private func updateButtonTitle(for state: MainViewModel.CreateButtonDisplayState) {
        var updatedConfiguration = createProjectButton.configuration
        
        switch state {
        case .both:
            var titleContainer = AttributeContainer()
            titleContainer.font = BridgeFont.subtitle1.font
            titleContainer.foregroundColor = BridgeColor.gray10
            updatedConfiguration?.attributedTitle = AttributedString("글쓰기", attributes: titleContainer)
            
        case .only:
            updatedConfiguration?.attributedTitle = nil
        }
        
        createProjectButton.configuration = updatedConfiguration
    }
}
