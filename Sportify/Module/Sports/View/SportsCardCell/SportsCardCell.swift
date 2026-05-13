import UIKit

class SportsCardCell: UICollectionViewCell {
    
    static let reuseID = "SportCardCell"
    
    private let sportImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 18
        iv.backgroundColor = .systemGray6
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let nameLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 15, weight: .medium)
        lbl.textColor = .label
        lbl.textAlignment = .center
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
        contentView.layer.cornerRadius = 20
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.03
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        layer.masksToBounds = false
        
        contentView.addSubview(sportImageView)
        contentView.addSubview(nameLabel)

        NSLayoutConstraint.activate([
            sportImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            sportImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            sportImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            sportImageView.heightAnchor.constraint(equalTo: sportImageView.widthAnchor),

            nameLabel.topAnchor.constraint(equalTo: sportImageView.bottomAnchor, constant: 10),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }

    func configure(with item: SportItem) {
        nameLabel.text = item.name
        sportImageView.image = UIImage(named: item.symbolName)
    }
}
