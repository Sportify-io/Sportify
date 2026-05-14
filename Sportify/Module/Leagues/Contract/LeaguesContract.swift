//
//  Contract.swift
//  Sportify
//
//  Created by Elsobky on 07/05/2026.
//

protocol LeaguesViewProtocol:AnyObject{
    func showLeagues(_ leagues :[League])
    func showLoading()
    func hideLoading()
    func showError(_ message: String, onRetry: (() -> Void)?)
}

protocol LeaguesPresenterProtocol:AnyObject{
    func viewDidLoad()
    func searchTextDidChange(_ text: String)
    func didSelectLeague(at index:Int)
}

protocol LeaguesRouterProtocol: AnyObject {
    func navigateToLeagueDetails(sport: APISport, league: League)
}
