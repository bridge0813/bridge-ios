//
//  BaseListView.swift
//  Bridge
//
//  Created by 엄지호 on 1/12/24.
//

import UIKit
import FlexLayout
import PinLayout
import RxSwift
import RxCocoa

/// 프로필에서 리스트(링크, 파일 등)를 보여주는 BaseView
class BaseListView: BaseView {
    // MARK: - UI
    let rootFlexContainer = UIView()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = 60
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        return tableView
    }()
    let placeholderContainer: UIView = {
        let view = UIView()
        view.layer.borderColor = BridgeColor.gray06.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        return view
    }()
    
    let placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "직무 경험과 관련하여 참고할 수 있는 링크를 입력하세요."
        label.font = BridgeFont.body2.font
        label.textColor = BridgeColor.gray04
        return label
    }()
    
    // MARK: - Layout
    override func configureLayouts() {
        addSubview(rootFlexContainer)
        rootFlexContainer.flex.define { flex in
            flex.addItem(tableView).display(.flex)
            flex.addItem(placeholderContainer).display(.none).height(52).padding(17, 16, 17, 16).define { flex in
                flex.addItem(placeholderLabel)
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        rootFlexContainer.pin.all()
        rootFlexContainer.flex.layout()
    }
}
