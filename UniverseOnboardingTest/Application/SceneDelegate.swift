//
//  SceneDelegate.swift
//  UniverseOnboardingTest
//
//  Created by Volodymyr Pysarenko on 05.06.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    static weak var shared: SceneDelegate?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        Self.shared = self
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        self.presentOnboardingFlow()
    }
    
    func presentMainApp() {
        let mainVC = AppViewController()
        setRootViewController(mainVC)
    }
}

private extension SceneDelegate {
    
    func presentOnboardingFlow() {
        let navVC = UINavigationController(rootViewController: OnboardingViewController())
        navVC.isNavigationBarHidden = true
        setRootViewController(navVC)
    }
    
    func setRootViewController(_ viewController: UIViewController) {
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
    }
    
}
