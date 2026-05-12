//
//  FavoriteLeagueBuilder.swift
//  Sportify
//
//  Created by Tasneem Hakeem on 11/05/2026.
//

import UIKit

class FavoritesBuilder {
    static func build() -> UIViewController {
        let view = FavoriteLeagueViewController(
            nibName: "FavoriteLeagueViewController",
            bundle: nil
        )

        let presenter = FavoritesPresenter()
        let router = FavoritesRouter()

        view.presenter = presenter
        presenter.view = view
        presenter.router = router
        router.viewController = view

        return view
    }
}
