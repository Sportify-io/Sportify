//
//  FavoriteLeagueRouter.swift
//  Sportify
//
//  Created by Tasneem Hakeem on 11/05/2026.
//

import UIKit

protocol FavoritesRouterProtocol {
    func navigateToLeagueDetails(favorite: FavoriteLeague, sport: APISport)
}

class FavoritesRouter: FavoritesRouterProtocol {

    weak var viewController: UIViewController?

    func navigateToLeagueDetails(favorite: FavoriteLeague, sport: APISport) {

        let league = League(
            leagueKey: Int(favorite.leagueKey),
            leagueName: favorite.leagueName,
            countryName: favorite.countryName,
            leagueImageURL: favorite.leagueImageUrl,
            countryImageURL: favorite.countryImageUrl
        )
        /*let vc = LeagueDetailsBuilder.build(league: league, sport: sport)
        viewController?.navigationController?.pushViewController(vc, animated: true)*/
    }
}
