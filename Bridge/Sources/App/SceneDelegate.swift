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
    private let socket: WebSocketService = DefaultWebSocketService()

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
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        let webSocketEndpoint = WebSocketEndpoint.connect
        let stompEndpoint = MessageStompEndpoint.connect
        socket.connect(endpoint: webSocketEndpoint, stompEndpoint: stompEndpoint)
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        socket.disconnect()
    }
}

