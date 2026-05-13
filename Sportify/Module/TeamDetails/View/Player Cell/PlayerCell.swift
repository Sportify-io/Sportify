//
//  PlayerCell.swift
//  Sportify
//
//  Created by Tasneem Hakeem on 13/05/2026.
//

import UIKit

class PlayerCell: UITableViewCell {

    @IBOutlet private weak var playerImageView: UIImageView!
    @IBOutlet private weak var playerNameLabel: UILabel!
    @IBOutlet private weak var positionAgeLabel: UILabel!
    @IBOutlet private weak var numberLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        playerImageView.layer.cornerRadius = 32
        playerImageView.clipsToBounds = true
        playerImageView.contentMode = .scaleAspectFill
    }

    func configure(with player: Player) {

        playerNameLabel.text = player.playerName


        let type = player.playerType.flatMap { $0.isEmpty ? nil : $0 } ?? ""
        let singularType = type.hasSuffix("s") ? String(type.dropLast()) : type
        if let age = player.playerAge, !age.isEmpty {
            positionAgeLabel.text = "\(singularType) · Age \(age)"
        } else {
            positionAgeLabel.text = singularType
        }

        numberLabel.text = (player.playerNumber?.isEmpty == false)
            ? player.playerNumber
            : "—"

        let placeholder = UIImage(systemName: "person.fill")?
            .withTintColor(
                UIColor(named: "primary") ?? .systemBlue,
                renderingMode: .alwaysOriginal
            )

        playerImageView.backgroundColor = UIColor(named: "CardSurface")

        if let urlString = player.playerImage, let url = URL(string: urlString) {
            playerImageView.sd_setImage(with: url, placeholderImage: placeholder)
        } else {
            playerImageView.image = placeholder
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
