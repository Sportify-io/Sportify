//
//  SplashBuilder.swift
//  Sportify
//
//  Created by Elsobky on 07/05/2026.
//

import UIKit

class LeaguesBuilder {
    static func build(sport :APISport) -> UIViewController {
        let view = LeaguesViewController(
            nibName: "LeaguesViewController",
            bundle: nil
        )
        
        let router = LeaguesRouter()
        let presenter = LeaguesPresenter()

        view.presenter = presenter
        view.sportType = sport
        presenter.view = view
        presenter.router = router
        presenter.sportType = sport
        router.viewController = view

        return view
    }
}
