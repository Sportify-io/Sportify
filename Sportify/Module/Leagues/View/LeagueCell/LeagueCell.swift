//
//  LeagueCellTableViewCell.swift
//  Sportify
//
//  Created by Elsobky on 07/05/2026.
//

import UIKit
import SDWebImage
class LeagueCell: UITableViewCell {

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var countryName: UILabel!
    @IBOutlet weak var countryImage: UIImageView!
    @IBOutlet weak var leagueName: UILabel!
    @IBOutlet weak var leagueImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none
        
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.08
        cardView.layer.shadowOffset = CGSize(width: 0, height: 4)
        cardView.layer.shadowRadius = 8
        cardView.layer.masksToBounds = false
        
        leagueImage.clipsToBounds = true
        countryImage.clipsToBounds = true
    }

    override func prepareForReuse(){
        super.prepareForReuse()
        leagueName.text = nil
        leagueImage.image = nil
        countryName.text = nil
        countryImage.image = nil
    }
    
    func configure(with league: League, type sport: APISport){
        countryName.text = league.countryName
        leagueName.text = league.leagueName
        leagueImage.setImage(urlString: league.leagueImageURL,type: sport)
        countryImage.setImage(urlString: league.countryImageURL, type: sport)
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        UIView.animate(withDuration: 0.1) {
            self.cardView.transform = highlighted ? CGAffineTransform(scaleX: 0.97, y: 0.97) : .identity
            self.cardView.alpha = highlighted ? 0.9 : 1.0
        }
    }
}
