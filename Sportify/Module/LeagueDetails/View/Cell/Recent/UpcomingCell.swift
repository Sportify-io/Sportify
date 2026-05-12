//
//  UpcomingCell.swift
//  Sportify
//
//  Created by Elsobky on 11/05/2026.
//

import UIKit

class UpcomingCell: UICollectionViewCell {

    static let reuseIdentifier = "UpcomingCell"

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var homeName: UILabel!
    @IBOutlet weak var awayName: UILabel!
    @IBOutlet weak var homeImage: UIImageView!
    @IBOutlet weak var awayImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        homeImage.image = nil
        awayImage.image = nil
    }

    func configure(with event: Event) {
        
        homeName.text = event.eventHomeTeam
        awayName.text = event.eventAwayTeam
        
        dateLabel.text = event.eventDate
        timeLabel.text = event.eventTime
        
        homeImage.sd_setImage(
            with: URL(string: event.homeTeamLogo ?? ""),
            placeholderImage: UIImage(named: "placeholder")
        )
        
        awayImage.sd_setImage(
            with: URL(string: event.awayTeamLogo ?? ""),
            placeholderImage: UIImage(named: "placeholder")
        )
    }
}
