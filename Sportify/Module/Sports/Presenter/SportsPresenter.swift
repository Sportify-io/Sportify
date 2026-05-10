//
//  SportsPresenter.swift
//  Sportify
//
//  Created by Tasneem Hakeem on 09/05/2026.
//

struct SportItem {
    let name: String
    let symbolName: String
    let sport: APISport
}

protocol SportsPresenterProtocol {
    func viewDidLoad()
    func didSelectSport(_ sport: APISport) 
}

class SportsPresenter: SportsPresenterProtocol {

    weak var view: SportsViewProtocol?
    var router: SportsRouterProtocol?

    private let sports: [SportItem] = [
        SportItem(name: "Football",   symbolName: "footballIcon",   sport: .football),
        SportItem(name: "Basketball", symbolName: "basketballIcon", sport: .basketball),
        SportItem(name: "Tennis",     symbolName: "tennisIcon",     sport: .tennis),
        SportItem(name: "Cricket",    symbolName: "cricketIcon",    sport: .cricket),
    ]

    func viewDidLoad() {
        view?.showSports(sports)
    }

    func didSelectSport(_ sport: APISport) {
        router?.navigateToLeagues(sport: sport)
    }
}
