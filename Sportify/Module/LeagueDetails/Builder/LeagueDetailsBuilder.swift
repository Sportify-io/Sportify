//
//  LeagueDetailsBuilder.swift
//  Sportify
//
//  Created by Elsobky on 12/05/2026.
//

import UIKit

final class LeagueDetailsBuilder {

    static func build(
        sport: APISport,
        league: League
    ) -> UIViewController {

        let view = LeagueDetailsViewController(
            nibName: "LeagueDetailsViewController",
            bundle: nil
        )

        let presenter = LeagueDetailsPresenter()

        let router = LeagueDetailsRouter()

        presenter.view = view
        presenter.router = router
        presenter.sportType = sport
        //presenter.leagueId = league.leagueKey
        presenter.league = league

        router.viewController = view
        view.presenter = presenter

        return view
    }
}
