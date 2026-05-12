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
        leagueId: Int
    ) {

        let detailsVC =
            LeagueDetailsBuilder.build(
                sport: sport,
                leagueId: leagueId
            )

        viewController?.navigationController?
            .pushViewController(
                detailsVC,
                animated: true
            )
    }
}
