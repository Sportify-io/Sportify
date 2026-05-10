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

        let destination = SportsBuilder.build()
        destination.modalPresentationStyle = .fullScreen
        viewController?.navigationController?.setViewControllers([destination], animated: true)
    }
}
