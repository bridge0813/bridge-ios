//
//  BarAppearanceConfigurable.swift
//  Bridge
//
//  Created by 정호윤 on 11/6/23.
//

import UIKit

/// 내비게이션 바와 탭 바의 appearance를 설정할 수 있는 프로토콜
typealias BarAppearanceConfigurable = NavigationBarAppearanceConfigurable & TabBarAppearanceConfigurable
    
/// 내비게이션 바의 appearance를 설정할 수 있는 프로토콜
protocol NavigationBarAppearanceConfigurable {
    func configureDefaultNavigationBarAppearance()
    func configureNoShadowNavigationBarAppearance()
}
    
/// 탭 바의 appearance를 설정할 수 있는 프로토콜
protocol TabBarAppearanceConfigurable {
    func configureDefaultTabBarAppearance()
}

// MARK: - Navigation bar
extension NavigationBarAppearanceConfigurable {
    func configureDefaultNavigationBarAppearance() {
        let backButtonImage = UIImage(named: "chevron.left")?
            .resize(to: CGSize(width: 24, height: 24))
            .withAlignmentRectInsets(UIEdgeInsets(top: 0, left: -2, bottom: 2, right: 0))
        
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithOpaqueBackground()
        navigationBarAppearance.setBackIndicatorImage(backButtonImage, transitionMaskImage: backButtonImage)
        navigationBarAppearance.titleTextAttributes = [
            .font: BridgeFont.subtitle1.font,
            .foregroundColor: BridgeColor.gray01
        ]
        navigationBarAppearance.shadowColor = BridgeColor.gray06
        
        UINavigationBar.appearance().tintColor = BridgeColor.gray01
        UINavigationBar.appearance().standardAppearance = navigationBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
        UINavigationBar.appearance().compactAppearance = navigationBarAppearance
    }
    
    func configureNoShadowNavigationBarAppearance() {
        let backButtonImage = UIImage(named: "chevron.left")?
            .resize(to: CGSize(width: 24, height: 24))
            .withAlignmentRectInsets(UIEdgeInsets(top: 0, left: -2, bottom: 2, right: 0))
        
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithOpaqueBackground()
        navigationBarAppearance.setBackIndicatorImage(backButtonImage, transitionMaskImage: backButtonImage)
        navigationBarAppearance.titleTextAttributes = [
            .font: BridgeFont.subtitle1.font,
            .foregroundColor: BridgeColor.gray01
        ]
        navigationBarAppearance.shadowColor = nil
        
        UINavigationBar.appearance().tintColor = BridgeColor.gray01
        UINavigationBar.appearance().standardAppearance = navigationBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
        UINavigationBar.appearance().compactAppearance = navigationBarAppearance
    }
}

// MARK: - Tab bar
extension TabBarAppearanceConfigurable {
    func configureDefaultTabBarAppearance() {
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.shadowColor = nil
        tabBarAppearance.stackedLayoutAppearance.selected.iconColor = BridgeColor.primary1
        tabBarAppearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: BridgeColor.primary1]
        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
    }
}

extension UIViewController: BarAppearanceConfigurable { }
