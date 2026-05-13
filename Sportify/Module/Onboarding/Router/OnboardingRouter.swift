//
//  OnboardingRouter.swift
//  Sportify
//
//  Created by Tasneem Hakeem on 08/05/2026.
//

import UIKit

protocol OnboardingRouterProtocol {
    func navigateToHome()
}

class OnboardingRouter: OnboardingRouterProtocol {
    weak var viewController: UIViewController?

    func navigateToHome() {
        UserDefaults.standard.set(true, forKey: "onboardingDone")

        guard let windowScene = viewController?.view.window?.windowScene,
              let sceneDelegate = windowScene.delegate as? SceneDelegate else { return }

        let tabBar = AppTabBarController()
        sceneDelegate.window?.rootViewController = tabBar

        UIView.transition(
            with: sceneDelegate.window!,
            duration: 0.3,
            options: .transitionCrossDissolve,
            animations: nil
        )
    }
}
