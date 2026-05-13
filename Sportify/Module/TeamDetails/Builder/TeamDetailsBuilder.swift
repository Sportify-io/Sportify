//
//  TeamDetailsContract.swift
//  Sportify
//
//  Created by Tasneem Hakeem on 13/05/2026.
//

import UIKit

final class TeamDetailsBuilder {
    static func build(team: Team) -> UIViewController {
        let view = TeamDetailsViewController(
            nibName: "TeamDetailsViewController",
            bundle: nil
        )
        let presenter = TeamDetailsPresenter()
        let router = TeamDetailsRouter()

        presenter.view = view
        presenter.router = router
        presenter.team = team
        router.viewController = view
        view.presenter = presenter

        return view
    }
}
