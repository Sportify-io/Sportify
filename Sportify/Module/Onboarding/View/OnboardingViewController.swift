//
//  OnboardingViewController.swift
//  Sportify
//
//  Created by Tasneem Hakeem on 08/05/2026.
//

import UIKit

protocol OnboardingViewProtocol: AnyObject {
    func configurePages(_ pages: [OnboardingPage])
    func scrollToPage(index: Int)
    func updatePageControl(index: Int)
    func updateButton(isLast: Bool)
}

class OnboardingViewController: UIPageViewController {

    private let nextButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.backgroundColor = UIColor(named: "Button")
        btn.setTitleColor(UIColor(named: "Primary"), for: .normal)
        btn.titleLabel?.font = .boldSystemFont(ofSize: 18)
        btn.layer.cornerRadius = 16
        btn.layer.shadowColor = UIColor.black.cgColor
        btn.layer.shadowOpacity = 0.08
        btn.layer.shadowOffset = CGSize(width: 0, height: 4)
        btn.layer.shadowRadius = 12
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    private let dotsStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 6
        sv.alignment = .center
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()

    private var dotViews: [UIView] = []

    var presenter: OnboardingPresenterProtocol!
    private var pages: [OnboardingPage] = []
    private var currentIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "onboarding1") ?? .systemBackground
        dataSource = self
        delegate = self
        setupOverlayUI()
        presenter.viewDidLoad()
    }

    private func setupOverlayUI() {
        view.addSubview(dotsStackView)
        view.addSubview(nextButton)

        updateButtonAppearance(isLast: false)
        nextButton.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)

        NSLayoutConstraint.activate([
            dotsStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -90),
            dotsStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dotsStackView.heightAnchor.constraint(equalToConstant: 10),

            nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
            nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            nextButton.heightAnchor.constraint(equalToConstant: 58)
        ])
    }

    private func buildDots(count: Int) {
        dotsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        dotViews = []

        for _ in 0..<count {
            let dot = UIView()
            dot.layer.cornerRadius = 5
            dot.clipsToBounds = true
            dotsStackView.addArrangedSubview(dot)
            dotViews.append(dot)
        }
        refreshDots(activeIndex: 0)
    }

    private func refreshDots(activeIndex: Int) {
        for (i, dot) in dotViews.enumerated() {
            let isActive = i == activeIndex

            dot.constraints.forEach { dot.removeConstraint($0) }

            dot.backgroundColor = isActive
                ? UIColor(named: "Primary")
                : UIColor(named: "Primary")?.withAlphaComponent(0.25)

            NSLayoutConstraint.activate([
                dot.heightAnchor.constraint(equalToConstant: 10),
                dot.widthAnchor.constraint(equalToConstant: isActive ? 28 : 10)
            ])
        }

        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut]) {
            self.dotsStackView.layoutIfNeeded()
        }
    }

    private func updateButtonAppearance(isLast: Bool) {
        let title = isLast ? "Get Started" : "Next"
        let arrow = isLast ? "" : "  →"

        let attributed = NSMutableAttributedString(
            string: title + arrow,
            attributes: [
                .font: UIFont.boldSystemFont(ofSize: 18),
                .foregroundColor: UIColor(named: "Primary") ?? .systemGreen
            ]
        )
        nextButton.setAttributedTitle(attributed, for: .normal)
    }

    @objc private func nextTapped() {
        presenter.didTapNext()
    }

    private func makePageVC(at index: Int) -> PageViewController {
        let vc = PageViewController(nibName: "PageViewController", bundle: nil)
        vc.page = pages[index]
        vc.index = index
        return vc
    }
}

// MARK: - OnboardingViewProtocol

extension OnboardingViewController: OnboardingViewProtocol {

    func configurePages(_ pages: [OnboardingPage]) {
        self.pages = pages
        buildDots(count: pages.count)
        let first = makePageVC(at: 0)
        setViewControllers([first], direction: .forward, animated: false)
    }

    func scrollToPage(index: Int) {
        let vc = makePageVC(at: index)
        setViewControllers([vc], direction: .forward, animated: true)
    }

    func updatePageControl(index: Int) {
        currentIndex = index
        refreshDots(activeIndex: index)
    }

    func updateButton(isLast: Bool) {
        updateButtonAppearance(isLast: isLast)
    }
}

// MARK: - UIPageViewControllerDataSource & Delegate

extension OnboardingViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let vc = viewController as? PageViewController, vc.index > 0 else { return nil }
        return makePageVC(at: vc.index - 1)
    }

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let vc = viewController as? PageViewController,
              vc.index < pages.count - 1 else { return nil }
        return makePageVC(at: vc.index + 1)
    }

    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool) {
        guard completed,
              let current = pageViewController.viewControllers?.first as? PageViewController
        else { return }
        refreshDots(activeIndex: current.index)
        presenter.didSwipeToPage(index: current.index)
    }
}
