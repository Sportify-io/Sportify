//
//  SportsRouter.swift
//  Sportify
//
//  Created by Tasneem Hakeem on 09/05/2026.
//

import UIKit

protocol SportsRouterProtocol {
    func navigateToLeagues(sport: APISport)  
}

class SportsRouter: SportsRouterProtocol {
    weak var viewController: UIViewController?

    func navigateToLeagues(sport: APISport) {
        let vc = LeaguesBuilder.build(sport: sport)
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
}
