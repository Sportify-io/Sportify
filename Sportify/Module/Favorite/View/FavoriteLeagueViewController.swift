//
//  FavoriteLeagueViewController.swift
//  Sportify
//
//  Created by Tasneem Hakeem on 11/05/2026.
//

import UIKit

protocol FavoriteLeagueViewProtocol: AnyObject {
    func showFavorites(_ leagues: [FavoriteLeagueViewModel])
}

class FavoriteLeagueViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyLabel: UILabel!

    @IBAction func addTestLeague() {
        presenter.addDummyLeague()
    }

    var presenter: FavoriteLeaguePresenterProtocol!
    private var leagues: [FavoriteLeagueViewModel] = []  

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.viewWillAppear()
    }

    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(
            UINib(nibName: "LeagueCell", bundle: nil),
            forCellReuseIdentifier: "LeagueCell"
        )
        tableView.backgroundColor = UIColor(named: "AppBackground")
        tableView.separatorStyle = .none
    }
}

extension FavoriteLeagueViewController: FavoriteLeagueViewProtocol {

    func showFavorites(_ leagues: [FavoriteLeagueViewModel]) {
        self.leagues = leagues
        tableView.reloadData()
        emptyLabel.isHidden = !leagues.isEmpty
    }
}

extension FavoriteLeagueViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int { leagues.count }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "LeagueCell", for: indexPath
        ) as! LeagueCell

        let vm = leagues[indexPath.row]
        let league = League(
            leagueKey:       vm.leagueKey,
            leagueName:      vm.leagueName,
            countryName:     vm.countryName,
            leagueImageURL:  vm.leagueImageUrl,
            countryImageURL: vm.countryImageUrl
        )
        cell.configure(with: league, type: vm.sport)
        return cell
    }

    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        presenter.didSelectLeague(at: indexPath.row)
    }

    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat { 100 }

    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        presenter.removeLeague(at: indexPath.row)
    }
}
