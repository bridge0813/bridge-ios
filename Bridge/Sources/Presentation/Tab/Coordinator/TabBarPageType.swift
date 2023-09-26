//
//  TabBarPageType.swift
//  Bridge
//
//  Created by 정호윤 on 2023/08/25.
//

import UIKit

enum TabBarPageType: Int, CaseIterable {
    case main = 0, management, chat, my
}

extension TabBarPageType {
    var tabBarItem: UITabBarItem {
        switch self {
        case .main:
            return UITabBarItem(
                title: "홈",
                image: UIImage(named: "house")?.resize(to: CGSize(width: 24, height: 24)),
                selectedImage: UIImage(named: "house.fill")?.resize(to: CGSize(width: 24, height: 24))
            )
            
        case .management:
            return UITabBarItem(
                title: "관리",
                image: UIImage(named: "folder")?.resize(to: CGSize(width: 24, height: 24)),
                selectedImage: UIImage(named: "folder.fill")?.resize(to: CGSize(width: 24, height: 24))
            )
            
        case .chat:
            return UITabBarItem(
                title: "채팅",
                image: UIImage(named: "ellipsis.message")?.resize(to: CGSize(width: 18, height: 18)),
                selectedImage: UIImage(named: "ellipsis.message.fill")?
                    .resize(to: CGSize(width: 18, height: 18))
                    .withRenderingMode(.alwaysOriginal)
            )
            
        case .my:
            return UITabBarItem(
                title: "마이",
                image: UIImage(named: "person")?.resize(to: CGSize(width: 24, height: 24)),
                selectedImage: UIImage(named: "person.fill")?.resize(to: CGSize(width: 24, height: 24))
            )
        }
    }
}
