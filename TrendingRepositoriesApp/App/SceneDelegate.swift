//
//  SceneDelegate.swift
//  TrendingRepositoriesApp
//
//  Created by Zara on 09/06/2023.
//

import UIKit
import TrendingRepositoriesKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let container = TrendingRepositoryContainer()
        let repositoriesListView = container.makeRepositoryListController()
        let navigationController = UINavigationController(rootViewController: repositoriesListView)
        
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = navigationController
        self.window = window
        self.window?.makeKeyAndVisible()
    }

    


}

