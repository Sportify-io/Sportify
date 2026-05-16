
import UIKit

class PlayerCell: UITableViewCell {


    @IBOutlet private weak var cardContainerView: UIView!
    @IBOutlet private weak var playerImageView: UIImageView!
    @IBOutlet private weak var numberBadgeView: UIView!
    @IBOutlet private weak var separatorLine: UIView!

    @IBOutlet private weak var playerNameLabel: UILabel!
    @IBOutlet private weak var positionAgeLabel: UILabel!
    @IBOutlet private weak var countryLabel: UILabel!
    @IBOutlet private weak var numberLabel: UILabel!

    @IBOutlet private weak var ratingPillView: UIView!
    @IBOutlet private weak var yellowCardPillView: UIView!
    @IBOutlet private weak var redCardPillView: UIView!

    @IBOutlet private weak var ratingLabel: UILabel!
    @IBOutlet private weak var yellowCardLabel: UILabel!
    @IBOutlet private weak var redCardLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        setupCard()
        setupImage()
        setupNumberBadge()
        setupStatRows()
    }


    private func setupCard() {
        cardContainerView.layer.cornerRadius = 16
        cardContainerView.layer.masksToBounds = false
        cardContainerView.backgroundColor = UIColor(named: "CardSurface") ?? .systemBackground
        cardContainerView.layer.shadowColor = UIColor.black.cgColor
        cardContainerView.layer.shadowOpacity = 0.07
        cardContainerView.layer.shadowOffset = CGSize(width: 0, height: 3)
        cardContainerView.layer.shadowRadius = 10
    }

    private func setupImage() {
        playerImageView.layer.cornerRadius = 36
        playerImageView.clipsToBounds = true
        playerImageView.contentMode = .scaleAspectFill
        playerImageView.backgroundColor = UIColor(named: "ImageBackground") ?? .systemGray6
        playerImageView.layer.borderWidth = 2
        playerImageView.layer.borderColor = (UIColor(named: "AccentPrimary") ?? .systemBlue)
            .withAlphaComponent(0.3).cgColor
    }

    private func setupNumberBadge() {
        numberBadgeView.layer.cornerRadius = 10
        numberBadgeView.layer.masksToBounds = true
        numberBadgeView.backgroundColor = (UIColor(named: "AccentPrimary") ?? .systemBlue)
            .withAlphaComponent(0.10)
    }

    private func setupStatRows() {
        ratingPillView.backgroundColor    = UIColor.systemGreen.withAlphaComponent(0.06)
        yellowCardPillView.backgroundColor = UIColor.clear
        redCardPillView.backgroundColor    = UIColor.systemRed.withAlphaComponent(0.05)
    }

    func configure(with player: Player) {
        configureHeader(player)
        configureStats(player)
        configureImage(player)
    }

    private func configureHeader(_ player: Player) {
        playerNameLabel.text = player.playerName ?? "Unknown"

        let rawType = player.playerType?.isEmpty == false ? player.playerType! : ""
        let singularType = rawType.hasSuffix("s") ? String(rawType.dropLast()) : rawType
        if let age = player.playerAge, !age.isEmpty {
            positionAgeLabel.text = singularType.isEmpty ? "Age \(age)" : "\(singularType)  ·  Age \(age)"
        } else {
            positionAgeLabel.text = singularType.isEmpty ? nil : singularType
        }

        if let country = player.playerCountry, !country.isEmpty {
            countryLabel.isHidden = false
            countryLabel.text = "🌍  \(country)"
        } else {
            countryLabel.isHidden = true
        }

        if let num = player.playerNumber, !num.isEmpty {
            numberLabel.text = "#\(num)"
        } else {
            numberLabel.text = "–"
        }
    }

    private func configureStats(_ player: Player) {
        if let ratingStr = player.playerRating,
           !ratingStr.isEmpty,
           let ratingVal = Double(ratingStr) {
            ratingLabel.text = String(format: "%.1f", ratingVal)
            ratingPillView.isHidden = false
        } else {
            ratingLabel.text = "–"
        }

        yellowCardLabel.text = player.playerYellowCards ?? "0"
        redCardLabel.text    = player.playerRedCards    ?? "0"
    }

    private func configureImage(_ player: Player) {
        let placeholder = UIImage(systemName: "person.fill")?
            .withTintColor(
                UIColor(named: "AccentPrimary") ?? .systemBlue,
                renderingMode: .alwaysOriginal
            )
        if let urlString = player.playerImage, let url = URL(string: urlString) {
            playerImageView.sd_setImage(with: url, placeholderImage: placeholder)
        } else {
            playerImageView.image = placeholder
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        playerImageView.image = nil
        countryLabel.isHidden = false
        ratingPillView.isHidden = false
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        cardContainerView.layer.shadowPath = UIBezierPath(
            roundedRect: cardContainerView.bounds,
            cornerRadius: 16
        ).cgPath
    }
}
