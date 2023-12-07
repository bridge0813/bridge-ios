//
//  UnreadMessageCountView.swift
//  Bridge
//
//  Created by 정호윤 on 12/7/23.
//

import UIKit
import FlexLayout
import PinLayout

// 안읽은 메시지 개수를 나타내는 뷰 (e.g. 1, 10, 999+ 등)
final class UnreadMessageCountView: BaseView {
    // MARK: - UI
    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemRed
        view.layer.cornerRadius = 9
        return view
    }()
    
    private let unreadMessageCountLabel: UILabel = {
        let label = UILabel()
        label.font = BridgeFont.caption1.font
        label.textColor = BridgeColor.gray09
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - Layout
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        backgroundView.pin.all()
//        backgroundView.flex.layout()
//    }
    
    override func configureLayouts() {
        addSubview(backgroundView)
        
        backgroundView.flex.justifyContent(.center).alignItems(.center).define { flex in
            flex.addItem(unreadMessageCountLabel)
        }
    }
}

extension UnreadMessageCountView {
    func configure(with unreadMessageCount: Int) {
        guard unreadMessageCount != 0 else {
            backgroundView.flex.size(0)
            return
        }
        
        switch unreadMessageCount {
        case 0:
            unreadMessageCountLabel.text = nil
            
        case 1 ..< 1000:
            unreadMessageCountLabel.text = "\(unreadMessageCount)"
            
        default:
            unreadMessageCountLabel.text = "999+"
        }
        
        let unreadMessageCountLabelSize = unreadMessageCountLabel.intrinsicContentSize
        let verticalPadding: CGFloat = 6
        let horizontalPadding: CGFloat = 2
        
        backgroundView.flex.width(unreadMessageCountLabelSize.width + verticalPadding * 2)
        backgroundView.flex.height(unreadMessageCountLabelSize.height + horizontalPadding * 2)
        
        backgroundView.flex.markDirty()
        backgroundView.flex.layout()
    }
}
