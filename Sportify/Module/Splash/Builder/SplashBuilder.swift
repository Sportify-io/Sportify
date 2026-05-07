//
//  SplashBuilder.swift
//  Sportify
//
//  Created by Elsobky on 07/05/2026.
//

import UIKit

class SplashBuilder {

    static func build() -> UIViewController {

        let view = SplashViewController(
            nibName: "SplashViewController",
            bundle: nil
        )

        let presenter = SplashPresenter()
        let router = SplashRouter()

        view.presenter = presenter

        presenter.view = view
        presenter.router = router

        router.viewController = view

        return view
    }
}
