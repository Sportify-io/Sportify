//
//  TeamDetailsPresenter.swift
//  Sportify
//
//  Created by Tasneem Hakeem on 13/05/2026.
//

import Foundation

final class TeamDetailsPresenter: TeamDetailsPresenterProtocol {

    weak var view: TeamDetailsViewProtocol?
    var router: TeamDetailsRouterProtocol?
    var team: Team?

    private var players: [Player] = []

    func viewDidLoad() {
        guard let team = team else { return }
        view?.setTeamName(team.teamName ?? "Team Details")
        view?.setTeamLogo(team.teamLogo)
        players = sortedPlayers(from: team.players ?? [])
        view?.reloadData()
    }

    var playersCount: Int {
        players.count
    }

    func getPlayer(at index: Int) -> Player {
        players[index]
    }

    private func sortedPlayers(from players: [Player]) -> [Player] {
        let order = ["Goalkeepers", "Defenders", "Midfielders", "Forwards"]
        return players.sorted {
            let i0 = order.firstIndex(of: $0.playerType ?? "") ?? 99
            let i1 = order.firstIndex(of: $1.playerType ?? "") ?? 99
            return i0 < i1
        }
    }
}
