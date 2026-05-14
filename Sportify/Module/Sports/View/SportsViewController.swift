import UIKit

protocol SportsViewProtocol: AnyObject {
    func showSports(_ sports: [SportItem])
    func updateTheme(isDark: Bool)
}

class SportsViewController: UIViewController {

    @IBOutlet weak var sportsCollectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    
    var presenter: SportsPresenterProtocol!
    private var sports: [SportItem] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        setupThemeButton()
        
        presenter.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "AppBackground")
        title = "Sports"
    }

    // MARK: - Theme Button
    
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
        // Delegate theme change to the presenter so it persists to UserDefaults
        presenter.toggleTheme()
    }

    // MARK: - CollectionView
    
    private func setupCollectionView() {
        sportsCollectionView.dataSource = self
        sportsCollectionView.delegate = self
        sportsCollectionView.backgroundColor = .clear
        
        sportsCollectionView.isScrollEnabled = true
        
        sportsCollectionView.register(
            SportsCardCell.self,
            forCellWithReuseIdentifier: SportsCardCell.reuseID
        )
        
        sportsCollectionView.collectionViewLayout = makeGridLayout()
    }

    private func makeGridLayout() -> UICollectionViewFlowLayout {
        
        let layout = UICollectionViewFlowLayout()
        
        let spacing: CGFloat = 16
        let sideInset: CGFloat = 20

        let totalPadding = (sideInset * 2) + spacing
        let itemWidth = (UIScreen.main.bounds.width - totalPadding) / 2
        
        let itemHeight = itemWidth + 45

        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        layout.minimumInteritemSpacing = spacing
        layout.minimumLineSpacing = spacing
        
        layout.sectionInset = UIEdgeInsets(
            top: spacing,
            left: sideInset,
            bottom: spacing,
            right: sideInset
        )
        
        return layout
    }
}

// MARK: - SportsViewProtocol

extension SportsViewController: SportsViewProtocol {
    
    func showSports(_ sports: [SportItem]) {
        
        self.sports = sports
        sportsCollectionView.reloadData()

        DispatchQueue.main.async {
            
            let rows = ceil(Double(self.sports.count) / 2.0)
            
            let layout = self.sportsCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
            
            let totalHeight =
            (CGFloat(rows) * layout.itemSize.height) +
            (CGFloat(max(0, rows - 1)) * layout.minimumLineSpacing) +
            layout.sectionInset.top +
            layout.sectionInset.bottom
            
            self.collectionViewHeight.constant = totalHeight
            
            self.view.layoutIfNeeded()
        }
    }
    
    func updateTheme(isDark: Bool) {

        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {

            window.overrideUserInterfaceStyle = isDark ? .dark : .light
        }

        navigationItem.rightBarButtonItem?.image = UIImage(
            systemName: isDark ? "sun.max.fill" : "moon.fill"
        )
    }
}

// MARK: - UICollectionViewDataSource & Delegate

extension SportsViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return sports.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: SportsCardCell.reuseID,
            for: indexPath
        ) as! SportsCardCell
        
        cell.configure(with: sports[indexPath.item])
        
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        let selectedSport = sports[indexPath.item].sport
        presenter.didSelectSport(selectedSport)
    }
}
