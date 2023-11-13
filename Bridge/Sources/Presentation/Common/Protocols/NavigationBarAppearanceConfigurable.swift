//
//  NavigationBarAppearanceConfigurable.swift
//  Bridge
//
//  Created by 정호윤 on 11/6/23.
//

import UIKit
    
/// 내비게이션 바의 appearance를 설정할 수 있는 프로토콜
protocol NavigationBarAppearanceConfigurable: UIViewController {
    func configureDefaultNavigationBarAppearance()
    func configureNoShadowNavigationBarAppearance()
    func configureTransparentNavigationBarAppearance()
}

// MARK: - Navigation bar
extension NavigationBarAppearanceConfigurable {
    var backButtonImage: UIImage? {
        UIImage(named: "chevron.left")?
            .resize(to: CGSize(width: 24, height: 24))
            .withAlignmentRectInsets(UIEdgeInsets(top: 0, left: -2, bottom: 2, right: 0))
    }
    
    func configureDefaultNavigationBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.setBackIndicatorImage(backButtonImage, transitionMaskImage: backButtonImage)
        appearance.titleTextAttributes = [.font: BridgeFont.subtitle1.font, .foregroundColor: BridgeColor.gray01]
        appearance.shadowColor = BridgeColor.gray06
        
        navigationController?.navigationBar.tintColor = BridgeColor.gray01
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
    }
    
    func configureNoShadowNavigationBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.setBackIndicatorImage(backButtonImage, transitionMaskImage: backButtonImage)
        appearance.titleTextAttributes = [.font: BridgeFont.subtitle1.font, .foregroundColor: BridgeColor.gray01]
        appearance.shadowColor = nil
        
        navigationController?.navigationBar.tintColor = BridgeColor.gray01
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
    }
    
    func configureTransparentNavigationBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.setBackIndicatorImage(backButtonImage, transitionMaskImage: backButtonImage)
        appearance.titleTextAttributes = [.font: BridgeFont.subtitle1.font, .foregroundColor: BridgeColor.gray01]
        
        navigationController?.navigationBar.tintColor = BridgeColor.gray01
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
    }
    
    func configureNavigationBarAppearance(with backgroundColor: UIColor) {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = backgroundColor
        appearance.setBackIndicatorImage(backButtonImage, transitionMaskImage: backButtonImage)
        appearance.titleTextAttributes = [.font: BridgeFont.subtitle1.font, .foregroundColor: BridgeColor.gray01]
        appearance.shadowColor = nil
        
        navigationController?.navigationBar.tintColor = BridgeColor.gray01
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
    }
}

extension UIViewController: NavigationBarAppearanceConfigurable { }
