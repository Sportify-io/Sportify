//
//  TeamCell.swift
//  Sportify
//
//  Created by Elsobky on 11/05/2026.
//

import UIKit

class TeamCell: UICollectionViewCell {
    
    static let reuseIdentifier = "TeamCell"
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var teamName: UILabel!
    @IBOutlet weak var teamImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI() {
        
        backgroundColor = .clear
        
        cardView.layer.cornerRadius = 18
        
        cardView.layer.shadowColor =
        UIColor.black.cgColor
        
        cardView.layer.shadowOpacity = 0.1
        
        cardView.layer.shadowOffset =
        CGSize(width: 0, height: 4)
        
        cardView.layer.shadowRadius = 10
        
        teamImage.layer.cornerRadius = 35
        teamImage.clipsToBounds = true
    }
    
    func configure(with team: Team) {
        
        teamName.text = team.teamName
        
        teamImage.sd_setImage(
            with: URL(string: team.teamLogo ?? ""),
            placeholderImage: UIImage(named: "placeholder")
        )
    }
    
    override var isHighlighted: Bool {
        
        didSet {
            
            UIView.animate(withDuration: 0.15) {
                
                self.transform =
                self.isHighlighted
                ? CGAffineTransform(scaleX: 0.95, y: 0.95)
                : .identity
            }
        }
    }
}
