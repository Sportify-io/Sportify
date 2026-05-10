//
//  SplashRouter.swift
//  Sportify
//
//  Created by Elsobky on 06/05/2026.

import UIKit


class LeaguesRouter: LeaguesRouterProtocol {
    weak var viewController: UIViewController?

    func navigateToLeagueDetails(with league: League) {
         let detailsVC = SplashBuilder.build()
         viewController?.navigationController?.pushViewController(detailsVC, animated: true)
    }
}
