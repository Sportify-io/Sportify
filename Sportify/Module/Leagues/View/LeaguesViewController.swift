//
// LeaguesViewController.swift
// Sportify
//

import UIKit

class LeaguesViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    var presenter: LeaguesPresenterProtocol!
    private var displayedLeagues: [League] = []
    private var activityIndicator: UIActivityIndicatorView?
    var sportType: APISport!
    private var animatedIndexPaths = Set<IndexPath>()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Leagues"
        setupTableView()
        setupSearchBar()
        presenter.viewDidLoad()
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor(named: "PrimaryColor")
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100

        let nib = UINib(nibName: "LeagueCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "LeagueCell")
    }

    private func setupSearchBar() {
        searchBar.delegate = self
        searchBar.placeholder = "Search Leagues"
    }
}

extension LeaguesViewController: LeaguesViewProtocol {
    func showLeagues(_ leagues: [League]) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.displayedLeagues = leagues
            self.tableView?.reloadData()
        }
    }

    func showLoading() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            if self.activityIndicator == nil {
                self.activityIndicator = UIActivityIndicatorView(style:.large)
                self.activityIndicator?.center = self.view.center
                self.activityIndicator?.hidesWhenStopped = true
                self.view.addSubview(self.activityIndicator!)
            }
            self.activityIndicator?.startAnimating()
            self.tableView.isHidden = true
        }
    }

    func hideLoading() {
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicator?.stopAnimating()
            self?.tableView.isHidden = false
        }
    }

    func showError(
        _ message: String,
        onRetry: (() -> Void)? = nil
    ) {
        
        DispatchQueue.main.async { [weak self] in
            
            let alert = UIAlertController(
                title: "Error",
                message: message,
                preferredStyle: .alert
            )
            
            let retryAction = UIAlertAction(
                title: "Retry",
                style: .default
            ) { _ in
                onRetry?()
            }
            
            let cancelAction = UIAlertAction(
                title: "Cancel",
                style: .cancel
            )
            
            alert.addAction(retryAction)
            alert.addAction(cancelAction)
            
            self?.present(alert, animated: true)
        }
    }
}

extension LeaguesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayedLeagues.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeagueCell", for: indexPath) as! LeagueCell
        cell.configure(with: displayedLeagues[indexPath.row],type: sportType)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("veiw click")
        tableView.deselectRow(at: indexPath, animated: true)
        presenter.didSelectLeague(at: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100  
    }
    
    func tableView(
        _ tableView: UITableView,
        willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath
    ) {

        guard !animatedIndexPaths.contains(indexPath)
        else { return }

        animatedIndexPaths.insert(indexPath)

        cell.alpha = 0

        cell.transform = CGAffineTransform(
            translationX: 0,
            y: 30
        )

        UIView.animate(
            withDuration: 0.35,
            delay: 0.1,
            usingSpringWithDamping: 0.85,
            initialSpringVelocity: 0.5,
            options: [.curveEaseOut, .allowUserInteraction]
        ) {

            cell.alpha = 1
            cell.transform = .identity
        }
    }
    
}


extension LeaguesViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter.searchTextDidChange(searchText)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        presenter.searchTextDidChange("")
    }
}
