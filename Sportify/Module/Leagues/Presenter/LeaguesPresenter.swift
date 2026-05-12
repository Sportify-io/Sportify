//
// LeaguesPresenter.swift
// Sportify
//
// Created by Elsobky on 06/05/2026.
//

import Foundation

class LeaguesPresenter: LeaguesPresenterProtocol {

    weak var view: LeaguesViewProtocol?
    var router: LeaguesRouterProtocol?
    var sportType: APISport?
    private var allLeagues: [League] = []
    private var filteredLeagues: [League] = []

    func viewDidLoad() {
        featchLeagues()
        view?.showLeagues(filteredLeagues)
    }
    
    func featchLeagues(){
        view?.showLoading()
        LeaguesService().getLeagues(sport: sportType ?? .football){result in
            switch(result){
            case .success(let response):
                self.allLeagues = response.result ?? []
                self.filteredLeagues = self.allLeagues
                self.view?.showLeagues(self.allLeagues)
                self.view?.hideLoading()
            case .failure(let error):
                self.view?.hideLoading()
                self.view?.showError(error.localizedDescription){
                    self.featchLeagues()
                }
            }
        }
    }

    func searchTextDidChange(_ text: String) {
        let searchText = text.trimmingCharacters(in:.whitespacesAndNewlines)

        if searchText.isEmpty {
            filteredLeagues = allLeagues
        } else {
            filteredLeagues = allLeagues.filter { league in
                let query = searchText.lowercased()
                
                let matchLeague = league.leagueName?.lowercased().contains(query) ?? false
                let matchCountry = league.countryName?.lowercased().contains(query) ?? false
                
                return matchLeague || matchCountry
            }
        }
        view?.showLeagues(filteredLeagues)
    }

    func didSelectLeague(at index: Int) {

        let league = filteredLeagues[index]

        router?.navigateToLeagueDetails(
            sport: sportType ?? .football,
            league: league
        )
    }

    private func loadDummyData() {
        allLeagues = [
            League(leagueKey: 1, leagueName: "Premier League", countryName: "England", leagueImageURL: "", countryImageURL: ""),
            League(leagueKey: 2, leagueName: "La Liga", countryName: "Spain", leagueImageURL: "", countryImageURL: ""),
            League(leagueKey: 3, leagueName: "Serie A", countryName: "Italy", leagueImageURL: "", countryImageURL: ""),
            League(leagueKey: 4, leagueName: "Bundesliga", countryName: "Germany", leagueImageURL: "", countryImageURL: ""),
            League(leagueKey: 5, leagueName: "Ligue 1", countryName: "France", leagueImageURL: "", countryImageURL: ""),
            League(leagueKey: 6, leagueName: "Egyptian League", countryName: "Egypt", leagueImageURL: "", countryImageURL: "")
        ]
        filteredLeagues = allLeagues
    }
}
