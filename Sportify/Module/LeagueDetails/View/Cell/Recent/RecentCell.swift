//
//  RecentCell.swift
//  Sportify
//
//  Created by Elsobky on 11/05/2026.
//

import UIKit

class RecentCell: UICollectionViewCell {

    static let reuseIdentifier = "RecentCell"
    @IBOutlet weak var cardView: UIView!

    @IBOutlet weak var timeLable: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var homeResult: UILabel!
    @IBOutlet weak var awayResult: UILabel!
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
        timeLable.text = event.eventTime
        let result = splitRangeString( event.eventFinalResult ?? "0 - 0")
        homeResult.text = result?.first ?? "0"
        awayResult.text = result?.second ?? "0"

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

func splitRangeString(_ rangeString: String) -> (first: String, second: String)? {
    let components = rangeString.components(separatedBy: "-")
    
    if components.count == 2 {
        let first = components[0].trimmingCharacters(in: .whitespaces)
        let second = components[1].trimmingCharacters(in: .whitespaces)
        
        return (first, second)
    }
    
    return nil
}
