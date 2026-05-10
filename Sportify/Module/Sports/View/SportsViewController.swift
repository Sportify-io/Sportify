//
//  SportsViewController.swift
//  Sportify
//
//  Created by Tasneem Hakeem on 09/05/2026.
//

import UIKit

protocol SportsViewProtocol: AnyObject {
    func showSports(_ sports: [SportItem])
}

class SportsViewController: UIViewController {

    @IBOutlet weak var sportsCollectionView: UICollectionView!

    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    
    var presenter: SportsPresenterProtocol!
    private var sports: [SportItem] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        presenter.viewDidLoad()
        
        title = "Sports"
    }

    private func setupCollectionView() {
        sportsCollectionView.dataSource = self
        sportsCollectionView.delegate = self
        sportsCollectionView.backgroundColor = .clear
        sportsCollectionView.register(
            SportsCardCell.self,
            forCellWithReuseIdentifier: SportsCardCell.reuseID
        )
        sportsCollectionView.collectionViewLayout = makeGridLayout()
    }

    private func makeGridLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 16
        let sideInset: CGFloat = 16

        let totalHorizontalPadding = (sideInset * 2) + spacing
        let itemWidth = (UIScreen.main.bounds.width - totalHorizontalPadding) / 2

        let topOffset: CGFloat = 80
        let bottomInset: CGFloat = 34
        let availableHeight = UIScreen.main.bounds.height - topOffset - bottomInset
        let itemHeight = (availableHeight - (spacing * 3)) / 2

        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        layout.minimumInteritemSpacing = spacing
        layout.minimumLineSpacing = spacing
        layout.sectionInset = UIEdgeInsets(top: spacing, left: sideInset, bottom: spacing, right: sideInset)
        return layout
    }
}

// mark: - SportsViewProtocol

extension SportsViewController: SportsViewProtocol {
    func showSports(_ sports: [SportItem]) {
        self.sports = sports
        sportsCollectionView.reloadData()

        let spacing: CGFloat = 16
        let layout = sportsCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let itemHeight = layout.itemSize.height
        let rows = ceil(Double(sports.count) / 2.0)
        let height = (itemHeight * CGFloat(rows)) + (spacing * (CGFloat(rows) + 1))
        collectionViewHeight.constant = height
        view.layoutIfNeeded()
    }
}

// mark: - UICollectionViewDataSource & Delegate

extension SportsViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        sports.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: SportsCardCell.reuseID,
            for: indexPath
        ) as! SportsCardCell
        cell.configure(with: sports[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        let selectedSport = sports[indexPath.item].sport
        presenter.didSelectSport(selectedSport)
    }
}
