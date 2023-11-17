//
//  SceneDelegate.swift
//  Bridge
//
//  Created by 정호윤 on 2023/08/21.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private var appCoordinator: AppCoordinator?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        let navigationController = UINavigationController()
        appCoordinator = AppCoordinator(navigationController: navigationController)
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        appCoordinator?.start()
    }
    
    // 웹 소켓 연결
    func sceneWillEnterForeground(_ scene: UIScene) {
        let webSocketEndpoint = WebSocketEndpoint.connect
        DefaultWebSocketService.shared.connect(webSocketEndpoint)
    }
    
    // 웹 소켓 연결 해제
    func sceneDidEnterBackground(_ scene: UIScene) {
        DefaultWebSocketService.shared.disconnect()
    }
}

