//
//  ChatRoomMenuView.swift
//  Bridge
//
//  Created by 엄지호 on 2023/09/26.
//

import UIKit
import FlexLayout
import PinLayout

final class ChatRoomMenuView: BaseView {
    private let rootFlexContainer = UIView()
    
    let leaveButton = MenuButton(title: "채팅방 나가기", imageName: "leave")
    let reportButton = MenuButton(title: "신고하기", imageName: "warning")
    let turnOffNotificationButton = MenuButton(title: "알림 끄기", imageName: "bell.crossline")
    
    override func configureLayouts() {
        addSubview(rootFlexContainer)
        
        rootFlexContainer.flex.direction(.column).padding(5).define { flex in
            flex.addItem(leaveButton).marginTop(5)
            flex.addItem(reportButton).marginTop(5)
            flex.addItem(turnOffNotificationButton).marginTop(5).marginBottom(5)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        rootFlexContainer.pin.all()
        rootFlexContainer.flex.layout()
    }
}
