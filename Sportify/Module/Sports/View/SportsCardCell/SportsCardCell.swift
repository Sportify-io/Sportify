import UIKit

class SportsCardCell: UICollectionViewCell {
    
    static let reuseID = "SportCardCell"
    
    private let sportImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 16
        iv.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        iv.backgroundColor = .systemGray6
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let nameLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 20, weight: .bold)
        lbl.textColor = .label
        lbl.textAlignment = .left
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    private func setupUI() {
        contentView.backgroundColor = .secondarySystemGroupedBackground
        contentView.layer.cornerRadius = 24
        contentView.clipsToBounds = true
        
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.contentView.layer.cornerRadius).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.06
        layer.shadowOffset = CGSize(width: 0, height: 6)
        layer.shadowRadius = 12
        layer.masksToBounds = false
        
        contentView.addSubview(sportImageView)
        contentView.addSubview(nameLabel)

        NSLayoutConstraint.activate([
            // Image takes up the top section of the card
            sportImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            sportImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            sportImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            // FIX: Lock image height to exactly 70% of the entire cell height
            sportImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.70),
            
            // Text takes up the bottom 30% safely
            nameLabel.topAnchor.constraint(equalTo: sportImageView.bottomAnchor, constant: 12),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            nameLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -12)
        ])
    }

    func configure(with item: SportItem) {
        nameLabel.text = item.name
        sportImageView.image = UIImage(named: item.symbolName)
    }
}
