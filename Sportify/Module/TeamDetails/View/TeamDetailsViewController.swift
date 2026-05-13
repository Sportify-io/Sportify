//
//  TeamDetailsViewController.swift
//  Sportify
//
//  Created by Tasneem Hakeem on 13/05/2026.
//

import UIKit
import SDWebImage

final class TeamDetailsViewController: UIViewController {
    @IBOutlet weak var teamName: UILabel!
    
    @IBOutlet private weak var logoImageView: UIImageView!
    @IBOutlet private weak var tableView: UITableView!

    private var activityIndicator: UIActivityIndicatorView?

    var presenter: TeamDetailsPresenterProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupTableView()
        presenter.viewDidLoad()
    }
}

private extension TeamDetailsViewController {

    func setupView() {
        view.backgroundColor = .systemBackground
        logoImageView.contentMode = .scaleAspectFit
    }

    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(
            UINib(nibName: "PlayerCell", bundle: nil),
            forCellReuseIdentifier: "PlayerCell"
        )
        tableView.separatorStyle = .none
        tableView.rowHeight = 90
        tableView.isScrollEnabled = false
    }
}

extension TeamDetailsViewController: TeamDetailsViewProtocol {

    func showLoading() {
        if activityIndicator == nil {
            activityIndicator = UIActivityIndicatorView(style: .large)
            activityIndicator?.center = view.center
            activityIndicator?.hidesWhenStopped = true
            view.addSubview(activityIndicator!)
        }
        activityIndicator?.startAnimating()
        tableView.isHidden = true
    }

    func hideLoading() {
        activityIndicator?.stopAnimating()
        tableView.isHidden = false
    }

    func reloadData() {
        tableView.reloadData()
    }

    func showError(message: String) {
        let alert = UIAlertController(
            title: "Error",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    func setTeamName(_ name: String) {
        title = name
        teamName.text = name
    }

    func setTeamLogo(_ url: String?) {
        guard let urlString = url,
              let imageURL = URL(string: urlString) else { return }
        logoImageView.sd_setImage(with: imageURL)
    }
}

// MARK: – UITableViewDataSource & Delegate
extension TeamDetailsViewController:
    UITableViewDataSource, UITableViewDelegate {

    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        presenter.playersCount
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "PlayerCell",
            for: indexPath
        ) as? PlayerCell else {
            return UITableViewCell()
        }
        cell.configure(with: presenter.getPlayer(at: indexPath.row))
        return cell
    }
}
