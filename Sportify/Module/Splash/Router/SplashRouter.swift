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
        destination.modalPresentationStyle = .fullScreen
        viewController?.navigationController?.setViewControllers([destination], animated: true)
    }

    private func resolveDestination() -> UIViewController {
        let onboardingDone = UserDefaults.standard.bool(forKey: "onboardingDone")

        if onboardingDone {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            return storyboard.instantiateViewController(withIdentifier: "home")
        } else {
            return OnboardingBuilder.build()
        }
    }
}
