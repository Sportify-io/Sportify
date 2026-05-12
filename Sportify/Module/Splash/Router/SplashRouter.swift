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
            return SportsBuilder.build()
            //return FavoritesBuilder.build()
        } else {
            return OnboardingBuilder.build()
        }
    }
}
