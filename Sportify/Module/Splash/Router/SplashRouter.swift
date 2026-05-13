//
//  SplashRouter.swift
//  Sportify
//
//  Created by Elsobky on 06/05/2026.
//

import UIKit

protocol SplashRouterProtocol {
    func navigateToHome()
}

class SplashRouter: SplashRouterProtocol {
    weak var viewController: UIViewController?

    func navigateToHome() {
        let destination = resolveDestination()

        guard let windowScene = viewController?.view.window?.windowScene,
              let sceneDelegate = windowScene.delegate as? SceneDelegate else { return }

        sceneDelegate.window?.rootViewController = destination

        UIView.transition(
            with: sceneDelegate.window!,
            duration: 0.3,
            options: .transitionCrossDissolve,
            animations: nil
        )
    }

    private func resolveDestination() -> UIViewController {
        let onboardingDone = UserDefaults.standard.bool(forKey: "onboardingDone")
        return onboardingDone ? AppTabBarController() : OnboardingBuilder.build()
    }
}
