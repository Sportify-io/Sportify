import UIKit

protocol SportsViewProtocol: AnyObject {
    func showSports(_ sports: [SportItem])
    func updateTheme(isDark: Bool)
}

final class SportsViewController: UIViewController {

    @IBOutlet private weak var sportsCollectionView: UICollectionView!
    
    var presenter: SportsPresenterProtocol!
    private var sports: [SportItem] = []
    
    private let sideInset: CGFloat = 24
    private let lineSpacing: CGFloat = 20

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupThemeButton()
        presenter.viewDidLoad()
        
        title = "Sports"
    }

    private func setupThemeButton() {
        let themeButton = UIBarButtonItem(
            image: UIImage(systemName: traitCollection.userInterfaceStyle == .dark ? "sun.max.fill" : "moon.fill"),
            style: .plain,
            target: self,
            action: #selector(toggleTheme)
        )
        navigationItem.rightBarButtonItem = themeButton
    }

    @objc private func toggleTheme() {
        presenter.toggleTheme()
    }

    private func setupCollectionView() {
        sportsCollectionView.dataSource = self
        sportsCollectionView.delegate = self
        sportsCollectionView.backgroundColor = .clear
        
        sportsCollectionView.isScrollEnabled = true
        sportsCollectionView.alwaysBounceVertical = true
        sportsCollectionView.showsVerticalScrollIndicator = false
        
        sportsCollectionView.register(
            SportsCardCell.self,
            forCellWithReuseIdentifier: SportsCardCell.reuseID
        )
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = lineSpacing
        layout.sectionInset = UIEdgeInsets(top: 16, left: sideInset, bottom: 16, right: sideInset)
        sportsCollectionView.collectionViewLayout = layout
    }
}

extension SportsViewController: SportsViewProtocol {
    
    func showSports(_ sports: [SportItem]) {
        self.sports = sports
        sportsCollectionView.reloadData()
        sportsCollectionView.setContentOffset(.zero, animated: false)
    }
    
    func updateTheme(isDark: Bool) {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.overrideUserInterfaceStyle = isDark ? .dark : .light
        }
        navigationItem.rightBarButtonItem?.image = UIImage(systemName: isDark ? "sun.max.fill" : "moon.fill")
    }
}

extension SportsViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sports.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: SportsCardCell.reuseID,
            for: indexPath
        ) as! SportsCardCell
        cell.configure(with: sports[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedSport = sports[indexPath.item].sport
        presenter.didSelectSport(selectedSport)
    }
}

extension SportsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let itemWidth = collectionView.bounds.width - (sideInset * 2)
        
        let availableVisibleHeight = collectionView.bounds.height - 32
        let totalSpacingNeeded = lineSpacing * 2
        let itemHeight = (availableVisibleHeight - totalSpacingNeeded) / 3
        
        return CGSize(width: itemWidth, height: itemHeight)
    }
}
