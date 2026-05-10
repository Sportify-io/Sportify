//
//  SportsCardCell.swift
//  Sportify
//
//  Created by Tasneem Hakeem on 09/05/2026.
//

import UIKit

class SportsCardCell: UICollectionViewCell {

    static let reuseID = "SportCardCell"

    /*private let iconContainer: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(named: "Primary")?.withAlphaComponent(0.08)
            ?? UIColor.systemGreen.withAlphaComponent(0.08)
        v.layer.cornerRadius = 45
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()*/

    private let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.tintColor = UIColor(named: "Primary") ?? .systemGreen
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    private let nameLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .boldSystemFont(ofSize: 20)   
        lbl.textColor = UIColor(named: "TextPrimary") ?? .label
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
        contentView.backgroundColor = UIColor(named: "CardSurface")
        contentView.layer.borderColor = UIColor(named: "CardBorder")?.cgColor
        contentView.layer.cornerRadius = 16
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.06
        contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
        contentView.layer.shadowRadius = 8
        contentView.clipsToBounds = false

        /*iconContainer.addSubview(iconImageView)
        contentView.addSubview(iconContainer)*/
        contentView.addSubview(iconImageView)
        contentView.addSubview(nameLabel)

        NSLayoutConstraint.activate([

            iconImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -16),
            iconImageView.widthAnchor.constraint(equalToConstant: 150),
            iconImageView.heightAnchor.constraint(equalToConstant: 150),

            nameLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 12),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
        ])
        
        /*NSLayoutConstraint.activate([
            iconContainer.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            iconContainer.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -16),
            iconContainer.widthAnchor.constraint(equalToConstant: 90),
            iconContainer.heightAnchor.constraint(equalToConstant: 90),

            iconImageView.centerXAnchor.constraint(equalTo: iconContainer.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: iconContainer.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 44),
            iconImageView.heightAnchor.constraint(equalToConstant: 44),

            nameLabel.topAnchor.constraint(equalTo: iconContainer.bottomAnchor, constant: 12),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
        ])*/
    }

    func configure(with item: SportItem) {
        nameLabel.text = item.name
        iconImageView.image = UIImage(named: item.symbolName)
    }
}
