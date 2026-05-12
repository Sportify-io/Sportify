//
//  FavoriteLeaguePresenter.swift
//  Sportify
//
//  Created by Tasneem Hakeem on 11/05/2026.
//

protocol FavoriteLeaguePresenterProtocol {
    func viewWillAppear()
    func didSelectLeague(at index: Int)
    func removeLeague(at index: Int)
    func addDummyLeague()
}

class FavoritesPresenter: FavoriteLeaguePresenterProtocol {

    weak var view: FavoriteLeagueViewProtocol?
    var router: FavoritesRouterProtocol?

    private let favorites: FavoritesServiceProtocol
    private var leagues: [FavoriteLeague] = []

    init(favorites: FavoritesServiceProtocol = FavoritesService.shared) {
        self.favorites = favorites
    }

    func viewWillAppear() {
        leagues = favorites.getAllFavorite()
        view?.showFavorites(leagues.map(mapToViewModel))
    }

    func didSelectLeague(at index: Int) {
        let favorite = leagues[index]
        let sport = APISport(rawValue: favorite.sport ?? "") ?? .football
        router?.navigateToLeagueDetails(favorite: favorite, sport: sport)
    }

    func removeLeague(at index: Int) {
        let key = Int(leagues[index].leagueKey)
        favorites.remove(leagueKey: key)
        leagues.remove(at: index)
        view?.showFavorites(leagues.map(mapToViewModel))
    }

    func addDummyLeague() {
        var league = League(leagueKey: 999, leagueName: "Test League", countryName: "Test Country", leagueImageURL: nil, countryImageURL: nil)
        
        favorites.save(league: league, sport: .basketball)
        
        viewWillAppear()
    }

    private func mapToViewModel(_ entity: FavoriteLeague) -> FavoriteLeagueViewModel {
        FavoriteLeagueViewModel(
            leagueKey: Int(entity.leagueKey),
            leagueName: entity.leagueName,
            countryName: entity.countryName,
            leagueImageUrl: entity.leagueImageUrl,
            countryImageUrl: entity.countryImageUrl,
            sport: APISport(rawValue: entity.sport ?? "") ?? .football
        )
    }
}
