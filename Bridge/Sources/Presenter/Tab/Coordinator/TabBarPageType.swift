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
            return UITabBarItem(title: "홈", image: UIImage(systemName: "house"), selectedImage: nil)
            
        case .management:
            return UITabBarItem(title: "관리", image: UIImage(systemName: "filemenu.and.cursorarrow"), selectedImage: nil)
            
        case .chat:
            return UITabBarItem(title: "채팅", image: UIImage(systemName: "message"), selectedImage: nil)
            
        case .my:
            return UITabBarItem(title: "마이페이지", image: UIImage(systemName: "person.circle"), selectedImage: nil)
        }
    }
}
