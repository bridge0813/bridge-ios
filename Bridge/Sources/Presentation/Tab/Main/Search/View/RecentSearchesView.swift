//
//  RecentSearchesView.swift
//  Bridge
//
//  Created by 엄지호 on 2/6/24.
//

import UIKit
import FlexLayout
import PinLayout
import RxSwift
import RxCocoa

final class RecentSearchesView: BaseView {
    // MARK: - UI
    private let rootFlexContainer: UIView = {
        let view = UIView()
        view.backgroundColor = BridgeColor.gray10
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.flex.width(73).height(24)
        label.text = "최근 검색어"
        label.textColor = BridgeColor.gray01
        label.font = BridgeFont.subtitle2.font
        return label
    }()
    
    private let removeAllButton: UIButton = {
        let button = UIButton()
        button.flex.width(45).height(14)
        button.setTitle("전체 삭제", for: .normal)
        button.setTitleColor(BridgeColor.gray04, for: .normal)
        button.titleLabel?.font = BridgeFont.caption1.font
        return button
    }()
    
    private let dividerView: UIView = {
        let divider = UIView()
        divider.flex.width(1).height(10)
        divider.backgroundColor = BridgeColor.gray06
        return divider
    }()
    
    private let toggleSearchHistoryButton: UIButton = {
        let button = UIButton()
        button.flex.width(66).height(14)
        button.setTitleColor(BridgeColor.gray04, for: .normal)
        button.titleLabel?.font = BridgeFont.caption1.font
        return button
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(RecentSearchCell.self)
        tableView.separatorStyle = .none
        tableView.rowHeight = 35
        return tableView
    }()
    
    // MARK: - Property
    /// 검색어 저장 기능 ON/OFF, 기본값은 false(저장 활성화)
    private var isSearchHistoryDisabled = UserDefaults.standard.bool(forKey: "isSearchHistoryDisabled")
    
    let recentSearchesUpdated = PublishSubject<[RecentSearch]>()
    
    var removeAllButtonTapped: Observable<Void> {
        return removeAllButton.rx.tap.asObservable()
    }
    
    var recentSearchSelected: Observable<RecentSearch> {
        return tableView.rx.modelSelected(RecentSearch.self).asObservable()
    }
    
    // MARK: - Configuration
    override func configureAttributes() {
        updateVisibilityForSearchHistory()
    }
    
    // MARK: - Layout
    override func configureLayouts() {
        addSubview(rootFlexContainer)
        
        rootFlexContainer.flex.padding(24, 15, 0, 15).define { flex in
            flex.addItem().direction(.row).justifyContent(.spaceBetween).alignItems(.center).define { flex in
                flex.addItem(titleLabel)
                flex.addItem().width(139).direction(.row).alignItems(.center).define { flex in
                    flex.addItem(removeAllButton)
                    flex.addItem(dividerView).marginLeft(14)
                    flex.addItem(toggleSearchHistoryButton).marginLeft(14)
                }
            }
            
            flex.addItem(tableView).grow(1).marginTop(15)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        rootFlexContainer.pin.all()
        rootFlexContainer.flex.layout()
    }
    
    // MARK: - bind
    override func bind() {
        // 최근 검색어 조회
        recentSearchesUpdated
            .bind(to: tableView.rx.items(
                cellIdentifier: RecentSearchCell.reuseIdentifier,
                cellType: RecentSearchCell.self
            )) { _, element, cell in
                cell.configure(with: element)
            }
            .disposed(by: disposeBag)
        
        // 검색어 저장 기능 ON/OFF
        toggleSearchHistoryButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.isSearchHistoryDisabled.toggle()
                UserDefaults.standard.set(owner.isSearchHistoryDisabled, forKey: "isSearchHistoryDisabled")
                owner.updateVisibilityForSearchHistory()
            })
            .disposed(by: disposeBag)
    }
}

extension RecentSearchesView {
    /// 검색어 저장 기능 ON/OFF에 따라 UI Hidden 처리
    private func updateVisibilityForSearchHistory() {
        titleLabel.isHidden = isSearchHistoryDisabled
        removeAllButton.isHidden = isSearchHistoryDisabled
        dividerView.isHidden = isSearchHistoryDisabled
        tableView.isHidden = isSearchHistoryDisabled
        toggleSearchHistoryButton.setTitle(isSearchHistoryDisabled ? "저장기능 켜기" : "저장기능 끄기", for: .normal)
    }
}
