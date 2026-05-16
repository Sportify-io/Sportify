//
//  AppTabBarController.swift
//  Sportify
//
//  Created by Tasneem Hakeem on 12/05/2026.
//

import UIKit

class AppTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
        setupAppearance()
    }

    private func setupTabs() {
        let sportsNav = makeNav(
            root: SportsBuilder.build(),
            title: "Sports",
            icon: "sportscourt"
        )

        let favoritesNav = makeNav(
            root: FavoritesBuilder.build(),
            title: "Favorites",
            icon: "heart"
        )

        viewControllers = [sportsNav, favoritesNav]
    }

    private func makeNav(
        root: UIViewController,
        title: String,
        icon: String
    ) -> UINavigationController {
        let nav = UINavigationController(rootViewController: root)
        nav.tabBarItem = UITabBarItem(
            title: title,
            image: UIImage(systemName: icon),
            selectedImage: UIImage(systemName: "\(icon).fill")
        )
        return nav
    }

    private func setupAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        
        appearance.backgroundColor = .white
        
        tabBar.tintColor = UIColor(named: "primary")
        tabBar.unselectedItemTintColor = .gray
        
        tabBar.standardAppearance = appearance
    }
}
