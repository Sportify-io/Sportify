//
//  PageViewController.swift
//  Sportify
//
//  Created by Tasneem Hakeem on 08/05/2026.
//

import UIKit

class PageViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    var page: OnboardingPage?
    var index: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }

    private func configure() {
        guard let page = page else { return }
        imageView.image = page.image
        titleLabel.text = page.title
        descriptionLabel.text = page.description
        
        imageView.layer.cornerRadius = 16
        imageView.clipsToBounds = true
    }
}
