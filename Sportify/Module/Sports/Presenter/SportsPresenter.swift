//
//  SportsPresenter.swift
//  Sportify
//
//  Created by Tasneem Hakeem on 09/05/2026.
//

struct SportItem {
    let name: String
    let symbolName: String
}

protocol SportsPresenterProtocol {
    func viewDidLoad()
}

class SportsPresenter: SportsPresenterProtocol {

    weak var view: SportsViewProtocol?
    var router: SportsRouterProtocol?

    private let sports: [SportItem] = [
        SportItem(name: "Football",  symbolName: "football"),
        SportItem(name: "Basketball", symbolName: "basketball"),
        SportItem(name: "Tennis",  symbolName: "tennis"),
        SportItem(name: "Cricket", symbolName: "cricket")
    ]

    func viewDidLoad() {
        view?.showSports(sports)
    }
}
