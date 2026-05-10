//
//  SportsBuilder.swift
//  Sportify
//
//  Created by Tasneem Hakeem on 09/05/2026.
//

import UIKit

class SportsBuilder {

    static func build() -> UIViewController {
        let view = SportsViewController(nibName: "SportsViewController", bundle: nil)

        let presenter = SportsPresenter()
        let router = SportsRouter()

        view.presenter = presenter
        presenter.view = view
        presenter.router = router
        router.viewController = view

        return view
    }
}
