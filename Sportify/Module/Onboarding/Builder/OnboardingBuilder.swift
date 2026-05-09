//
//  OnboardingBuilder.swift
//  Sportify
//
//  Created by Tasneem Hakeem on 08/05/2026.
//

import UIKit

class OnboardingBuilder {

    static func build() -> UIViewController {

        let view = OnboardingViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal
        )

        let presenter = OnboardingPresenter()
        let router = OnboardingRouter()

        view.presenter = presenter
        presenter.view = view
        presenter.router = router
        router.viewController = view

        return view
    }
}
