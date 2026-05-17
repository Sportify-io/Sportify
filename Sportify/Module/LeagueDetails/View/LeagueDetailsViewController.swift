//
//  LeagueDetailsViewController.swift
//  Sportify
//

import UIKit

final class LeagueDetailsViewController: UIViewController {
    
    @IBOutlet private weak var collectionView: UICollectionView!
    private var favoriteBarButton: UIBarButtonItem!
    private var activityIndicator: UIActivityIndicatorView?

    var presenter: LeagueDetailsPresenterProtocol!

    private enum SectionType {
        case upcoming
        case teams
        case recent
    }
    
    private var activeSections: [SectionType] = []

    private var animatedIndexPaths = Set<IndexPath>()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupCollectionView()
        presenter.viewDidLoad()
    }
    
    @IBAction func addToFavTapped(_ sender: UIButton) {
        presenter.toggleFavorite()
    }
}

private extension LeagueDetailsViewController {

    func setupView() {
        view.backgroundColor = .systemBackground
        title = "League Details"
        
        favoriteBarButton = UIBarButtonItem(
            image: UIImage(systemName: "heart"),
            style: .plain,
            target: self,
            action: #selector(favoriteTapped)
        )
        navigationItem.rightBarButtonItem = favoriteBarButton
        
        updateFavoriteButton(isFavorite: presenter.isFavorite)
    }
    
    @objc func favoriteTapped() {
        presenter.toggleFavorite()
    }

    func setupCollectionView() {
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.dataSource = self

        registerCells()
        collectionView.collectionViewLayout = createCompositionalLayout()
    }

    func registerCells() {
        collectionView.register(UINib(nibName: "UpcomingCell", bundle: nil), forCellWithReuseIdentifier: "UpcomingCell")
        collectionView.register(UINib(nibName: "RecentCell", bundle: nil), forCellWithReuseIdentifier: "RecentCell")
        collectionView.register(UINib(nibName: "TeamCell", bundle: nil), forCellWithReuseIdentifier: "TeamCell")
        
        collectionView.register(
            SectionHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: SectionHeaderView.reuseIdentifier
        )
    }
    
    func updateActiveSections() {
        activeSections.removeAll()
        
        if presenter.upcomingEventsCount > 0 {
            activeSections.append(.upcoming)
        }
        
        if presenter.teamsCount > 0 {
            activeSections.append(.teams)
        }
        
        if presenter.recentEventsCount > 0 {
            activeSections.append(.recent)
        }
        
        if activeSections.isEmpty {
            let noDataLabel = UILabel()
            noDataLabel.text = "There is no data for this league"
            noDataLabel.textColor = .secondaryLabel
            noDataLabel.textAlignment = .center
            noDataLabel.font = .systemFont(ofSize: 16, weight: .medium)
            collectionView.backgroundView = noDataLabel
        } else {
            collectionView.backgroundView = nil
        }
    }
}

private extension LeagueDetailsViewController {

    func createCompositionalLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            guard let self = self else { return nil }
            
            guard sectionIndex < self.activeSections.count else { return nil }
            
            switch self.activeSections[sectionIndex] {
            case .upcoming:
                return self.createUpcomingSection()
            case .teams:
                return self.createTeamsSection()
            case .recent:
                return self.createRecentSection()
            }
        }
    }

    func createUpcomingSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .absolute(170))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        section.interGroupSpacing = 12
        section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 0, bottom: 20, trailing: 0)
        section.boundarySupplementaryItems = [createHeader()]

        return section
    }

    func createRecentSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(110))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(110))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10
        section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 16, bottom: 20, trailing: 16)
        section.boundarySupplementaryItems = [createHeader()]

        return section
    }

    func createTeamsSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(140), heightDimension: .absolute(160))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 16
        section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 16, bottom: 20, trailing: 16)
        section.boundarySupplementaryItems = [createHeader()]

        return section
    }

    func createHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(44)),
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
    }
}

extension LeagueDetailsViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return activeSections.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch activeSections[section] {
        case .upcoming:
            return presenter.upcomingEventsCount
        case .teams:
            return presenter.teamsCount
        case .recent:
            return presenter.recentEventsCount
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch activeSections[indexPath.section] {
        case .upcoming:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UpcomingCell", for: indexPath) as? UpcomingCell else {
                return UICollectionViewCell()
            }
            let event = presenter.getUpcomingEvent(at: indexPath.item)
            cell.configure(with: event)
            return cell

        case .teams:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TeamCell", for: indexPath) as? TeamCell else {
                return UICollectionViewCell()
            }
            let team = presenter.getTeam(at: indexPath.item)
            cell.configure(with: team)
            return cell

        case .recent:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecentCell", for: indexPath) as? RecentCell else {
                return UICollectionViewCell()
            }
            let event = presenter.getRecentEvent(at: indexPath.item)
            cell.configure(with: event)
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader,
              let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeaderView.reuseIdentifier, for: indexPath) as? SectionHeaderView
        else {
            return UICollectionReusableView()
        }

        switch activeSections[indexPath.section] {
        case .upcoming:
            header.titleLabel.text = "Upcoming Matches"
        case .teams:
            header.titleLabel.text = "Teams"
        case .recent:
            header.titleLabel.text = "Recent Results"
        }

        return header
    }
}

extension LeagueDetailsViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard activeSections[indexPath.section] == .teams else { return }
        presenter.didSelectTeam(at: indexPath.item)
    }
}

extension LeagueDetailsViewController {

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard !animatedIndexPaths.contains(indexPath) else { return }
        animatedIndexPaths.insert(indexPath)

        cell.alpha = 0

        switch activeSections[indexPath.section] {
        case .recent:
            cell.transform = CGAffineTransform(translationX: 0, y: 30)
        default:
            cell.transform = CGAffineTransform(translationX: 40, y: 0)
        }

        let sectionDelay = Double(indexPath.section) * 0.12
        let itemDelay = Double(indexPath.item) * 0.04

        UIView.animate(
            withDuration: 0.55,
            delay: sectionDelay + itemDelay,
            usingSpringWithDamping: 0.85,
            initialSpringVelocity: 0.5,
            options: [.curveEaseOut, .allowUserInteraction]
        ) {
            cell.alpha = 1
            cell.transform = .identity
        }
    }

    func resetAnimations() {
        animatedIndexPaths.removeAll()
    }
}

extension LeagueDetailsViewController: LeagueDetailsViewProtocol {

    func showLoading() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            if self.activityIndicator == nil {
                self.activityIndicator = UIActivityIndicatorView(style: .large)
                self.activityIndicator?.center = self.view.center
                self.activityIndicator?.hidesWhenStopped = true
                self.view.addSubview(self.activityIndicator!)
            }
            self.activityIndicator?.startAnimating()
            self.collectionView.isHidden = true
        }
    }

    func hideLoading() {
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicator?.stopAnimating()
            self?.collectionView.isHidden = false
        }
    }

    func reloadData() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.resetAnimations()
            self.updateActiveSections()
            self.collectionView.reloadData()
        }
    }

    func showError(_ message: String, onRetry: (() -> Void)? = nil) {
        DispatchQueue.main.async { [weak self] in
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            let retryAction = UIAlertAction(title: "Retry", style: .default) { _ in onRetry?() }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            
            alert.addAction(retryAction)
            alert.addAction(cancelAction)
            self?.present(alert, animated: true)
        }
    }
    
    func updateFavoriteButton(isFavorite: Bool) {
        favoriteBarButton.image = UIImage(systemName: isFavorite ? "heart.fill" : "heart")
        favoriteBarButton.tintColor = isFavorite ? .systemRed : nil
    }
}
