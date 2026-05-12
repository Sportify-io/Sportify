//
//  SplashRouter.swift
//  Sportify
//
//  Created by Elsobky on 06/05/2026.

import UIKit


class LeaguesRouter: LeaguesRouterProtocol {
    weak var viewController: UIViewController?

    func navigateToLeagueDetails(
        sport: APISport,
        league: League
    ) {

        let detailsVC =
            LeagueDetailsBuilder.build(
                sport: sport,
                league: league
            )

        viewController?.navigationController?
            .pushViewController(
                detailsVC,
                animated: true
            )
    }
}
