//
//  SplashViewController.swift
//  Sportify
//
//  Created by Elsobky on 06/05/2026.
//

import UIKit

protocol SplashViewProtocol: AnyObject {
    func startAnimation()
    func showAppName()
    func stopAnimation()
    func zoomAndNavigate()
}

class SplashViewController: UIViewController {

    @IBOutlet weak var ballImageView: UIImageView!
    @IBOutlet weak var appNameLabel: UILabel!
    
    var presenter: SplashPresenterProtocol!
    
    private var animator: UIDynamicAnimator!
    private var gravity: UIGravityBehavior!
    private var collision: UICollisionBehavior!
    private var itemBehavior: UIDynamicItemBehavior!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appNameLabel.alpha = 0
        presenter.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter.viewDidAppear()
    }
}

extension SplashViewController: SplashViewProtocol {
    
    func startAnimation() {
        setupInitialPosition()
        setupPhysics()
    }
    
    func showAppName() {
        appNameLabel.center = CGPoint(
            x: view.center.x,
            y: view.center.y + ballImageView.frame.height / 2 + 20
        )
        
        UIView.animate(
            withDuration: 0.6,
            delay: 0.1,
            options: [.curveEaseIn],
            animations: {
                self.appNameLabel.alpha = 1
            },
            completion: { _ in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                    self.presenter.didFinishShowingAppName()
                }
            }
        )
    }
    
    func stopAnimation() {
        animator.removeAllBehaviors()
        
        UIView.animate(
            withDuration: 0.25,
            delay: 0,
            options: [.curveEaseOut],
            animations: {
                self.ballImageView.center.y = self.view.center.y
            }
        )
    }
    
    func zoomAndNavigate() {
        
        let screenDiagonal = sqrt(
            pow(view.bounds.width, 2) +
            pow(view.bounds.height, 2)
        )
        let scaleNeeded = (screenDiagonal / ballImageView.frame.width) * 2.2
        UIView.animate(withDuration: 0.3) {
            self.appNameLabel.alpha = 0
        }
        
        let spin = CABasicAnimation(keyPath: "transform.rotation.z")
        spin.fromValue = 0
        spin.toValue = CGFloat.pi * 2
        spin.duration = 1.2
        spin.repeatCount = .infinity
        spin.isCumulative = true
        ballImageView.layer.add(spin, forKey: "spinAnimation")
        
        UIView.animate(
            withDuration: 0.7,
            delay: 0.15,
            options: [.curveEaseIn],
            animations: {
                self.ballImageView.center    = self.view.center
                self.ballImageView.transform = CGAffineTransform(scaleX: scaleNeeded,
                                                                  y: scaleNeeded)
                self.ballImageView.alpha     = 0
            },
            completion: { _ in
                self.ballImageView.layer.removeAnimation(forKey: "spinAnimation")
                self.presenter.didFinishZoom()
            }
        )
    }
}

extension SplashViewController: UICollisionBehaviorDelegate {
    
    private func setupInitialPosition() {
        ballImageView.center = CGPoint(
            x: view.center.x,
            y: -ballImageView.frame.height
        )
    }
    
    private func setupPhysics() {
        animator = UIDynamicAnimator(referenceView: view)
        
        gravity = UIGravityBehavior(items: [ballImageView])
        gravity.magnitude = 2.5
        
        collision = UICollisionBehavior(items: [ballImageView])
        let groundY = view.center.y + ballImageView.frame.height / 2
        
        collision.addBoundary(
            withIdentifier: "ground" as NSString,
            from: CGPoint(x: 0, y: groundY),
            to: CGPoint(x: view.bounds.width, y: groundY)
        )
        
        collision.collisionDelegate = self
        
        itemBehavior = UIDynamicItemBehavior(items: [ballImageView])
        itemBehavior.elasticity = 0.65
        itemBehavior.allowsRotation = false
        
        animator.addBehavior(gravity)
        animator.addBehavior(collision)
        animator.addBehavior(itemBehavior)
    }
    
    func collisionBehavior(_ behavior: UICollisionBehavior,
                           beganContactFor item: UIDynamicItem,
                           withBoundaryIdentifier identifier: NSCopying?,
                           at p: CGPoint) {
        
        guard identifier as? String == "ground" else { return }
        presenter.didBounce()
    }
}
