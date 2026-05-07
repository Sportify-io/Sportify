//
//  SplashPresenter.swift
//  Sportify
//
//  Created by Elsobky on 06/05/2026.
//

import Foundation

protocol SplashPresenterProtocol {
    func viewDidLoad()
    func viewDidAppear()
    func didBounce()
    func didFinishShowingAppName()
    func didFinishZoom()
}

class SplashPresenter: SplashPresenterProtocol {
    
    weak var view: SplashViewProtocol?
    var router: SplashRouterProtocol?
    
    private var bounceCount = 0
    private let maxBounces = 5
    
    func viewDidLoad() {}
    
    func viewDidAppear() {
        view?.startAnimation()
    }
    
    func didBounce() {
        bounceCount += 1
        
        if bounceCount >= maxBounces {
            handleFinish()
        }
    }
    
    private func handleFinish() {
        view?.stopAnimation()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.view?.showAppName()
        }
    }
    
    func didFinishShowingAppName() {
        view?.zoomAndNavigate()
    }
    
    func didFinishZoom() {
        router?.navigateToHome()
    }
}
