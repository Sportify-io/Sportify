//
//  SplashRouter.swift
//  Sportify
//
//  Created by Elsobky on 06/05/2026.
//

import UIKit

protocol SplashRouterProtocol {
    func navigateToHome()
}

class SplashRouter: SplashRouterProtocol {
    
    weak var viewController: UIViewController?
    
    func navigateToHome() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "home")
        vc.modalPresentationStyle = .fullScreen
        
        viewController?.present(vc, animated: true)
    }
}
