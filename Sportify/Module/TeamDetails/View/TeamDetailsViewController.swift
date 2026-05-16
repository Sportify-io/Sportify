import UIKit
import SDWebImage

final class SelfSizingTableView: UITableView {
    override var contentSize: CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
}

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

        tableView.isScrollEnabled = false
        tableView.alwaysBounceVertical = false

        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 220
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
        tableView.invalidateIntrinsicContentSize()
    }

    func showError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
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

extension TeamDetailsViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.playersCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
