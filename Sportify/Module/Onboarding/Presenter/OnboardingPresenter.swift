//
//  OnboardingPresenter.swift
//  Sportify
//
//  Created by Tasneem Hakeem on 07/05/2026.
//

import UIKit

protocol OnboardingPresenterProtocol {
    func viewDidLoad()
    func didTapNext()
    func didSwipeToPage(index: Int)
}

class OnboardingPresenter: OnboardingPresenterProtocol {

    weak var view: OnboardingViewProtocol?
    var router: OnboardingRouterProtocol?

    private let pages: [OnboardingPage] = [
        OnboardingPage(
            title: "Welcome to Sportify",
            description: "Your all-in-one app to discover sports, explore leagues, and stay connected to the games you love.",
            image: UIImage(named: "ball")
        ),
        OnboardingPage(
            title: "Follow Leagues & Matches",
            description: "Track leagues, upcoming events, and latest scores with real-time updates and detailed views.",
            image: UIImage(named: "basketball")
        ),
        OnboardingPage(
            title: "Your Favorites, Anytime",
            description: "Save your favorite leagues and access them anytime, even when you're offline.",
            image: UIImage(named: "tennis")
        ),
    ]

    private var currentIndex = 0

    func viewDidLoad() {
        view?.configurePages(pages)
        view?.updateButton(isLast: false)
    }

    func didTapNext() {
        if currentIndex == pages.count - 1 {
            router?.navigateToHome()
        } else {
            currentIndex += 1
            view?.scrollToPage(index: currentIndex)
            view?.updatePageControl(index: currentIndex)
            view?.updateButton(isLast: currentIndex == pages.count - 1)
        }
    }

    func didSwipeToPage(index: Int) {
        currentIndex = index
        view?.updateButton(isLast: currentIndex == pages.count - 1)
    }
}
