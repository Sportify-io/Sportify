//
//  LeaguesDetailsContract.swift
//  Sportify
//
//  Created by Elsobky on 12/05/2026.
//

import Foundation
import UIKit

protocol LeagueDetailsViewProtocol: AnyObject {

    func showLoading()

    func hideLoading()

    func showError(message: String)

    func reloadData()
}

protocol LeagueDetailsPresenterProtocol: AnyObject {

    var upcomingEventsCount: Int { get }

    var recentEventsCount: Int { get }

    var teamsCount: Int { get }

    func viewDidLoad()

    func getUpcomingEvent(at index: Int) -> Event

    func getRecentEvent(at index: Int) -> Event

    func getTeam(at index: Int) -> Team

    func didSelectTeam(at index: Int)
}

protocol LeagueDetailsRouterProtocol: AnyObject {

    func navigateToTeamDetails(with team: Team)
}
