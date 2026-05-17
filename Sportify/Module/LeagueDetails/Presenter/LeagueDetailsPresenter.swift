//
//  LeagueDetailsPresenter.swift
//  Sportify
//
//  Created by Elsobky on 12/05/2026.
//

import Foundation

final class LeagueDetailsPresenter:
    LeagueDetailsPresenterProtocol {

    weak var view: LeagueDetailsViewProtocol?

    var router: LeagueDetailsRouterProtocol?

    var sportType: APISport?
    
    var league: League?
    
    private let favoritesService: FavoritesServiceProtocol

    private var upcomingEvents: [Event] = []

    private var recentEvents: [Event] = []

    private var teams: [Team] = []
    
    init(favoritesService: FavoritesServiceProtocol = FavoritesService.shared) {
            self.favoritesService = favoritesService
    }

    var isFavorite: Bool {
        guard let id = league?.leagueKey else { return false }
        return favoritesService.isFavorite(leagueKey: id)
    }

    func toggleFavorite() {
        guard let sport  = sportType,
              let league = league else { return }

        if isFavorite {
            favoritesService.remove(leagueKey: league.leagueKey ?? 0)
        } else {
            favoritesService.save(league: league, sport: sport)
        }
        view?.updateFavoriteButton(isFavorite: isFavorite)
    }

    func viewDidLoad() {

        fetchUpcomingEvents()

        fetchTeams()
    }

    var upcomingEventsCount: Int {
        upcomingEvents.count
    }

    var recentEventsCount: Int {
        recentEvents.count
    }

    var teamsCount: Int {
        teams.count
    }


    func getUpcomingEvent(at index: Int) -> Event {
        upcomingEvents[index]
    }

    func getRecentEvent(at index: Int) -> Event {
        recentEvents[index]
    }

    func getTeam(at index: Int) -> Team {
        teams[index]
    }

    private func fetchUpcomingEvents() {

        guard let sport = sportType,
              let leagueId = league?.leagueKey else {
            return
        }

        view?.showLoading()

        let fromDate = formattedDate(days: -30)

        let toDate = formattedDate(days: 14)

        FixturesService().getFixtures(
            sport: sport,
            leagueId: leagueId,
            from: fromDate,
            to: toDate
        ) { [weak self] result in

            guard let self = self else { return }

            DispatchQueue.main.async {

                self.view?.hideLoading()

                switch result {

                case .success(let response):

                    self.upcomingEvents = Array((response.result?.filter { event in
                        return self.isFuture(dateString: event.eventDate ?? "2024-10-15")
                    } ?? []).reversed())
                    self.recentEvents = response.result?.filter { event in
                        return !self.isFuture(dateString: event.eventDate ?? "2024-10-15")
                    } ?? []
                    

                    self.view?.reloadData()

                case .failure(let error):

                    self.view?.showError(error.localizedDescription){
                        self.fetchUpcomingEvents()
                    }
                }
            }
        }
    }

    private func fetchTeams() {

        guard let sport = sportType,
              let leagueId = league?.leagueKey else {
            return
        }

        TeamsService().getTeams(
            sport: sport,
            leagueId: leagueId
        ) { [weak self] result in

            guard let self = self else { return }

            DispatchQueue.main.async {

                switch result {

                case .success(let response):

                    self.teams =
                        response.result ?? []

                    self.view?.reloadData()

                case .failure(let error):

                    self.view?.showError(error.localizedDescription){
                        self.fetchTeams()
                    }
                }
            }
        }
    }

    func didSelectTeam(at index: Int) {

        guard index < teams.count else {
            return
        }

        let team = teams[index]

        router?.navigateToTeamDetails(with: team)
    }

    private func formattedDate(days: Int) -> Date {
        let calendar = Calendar.current
        let date = calendar.date(
            byAdding: .day,
            value: days,
            to: Date()
        ) ?? Date()
        
        return date
    }
    
    private func isFuture(dateString: String) -> Bool {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        let todayString = formatter.string(from: Date())
        
        return dateString >= todayString
    }
}
