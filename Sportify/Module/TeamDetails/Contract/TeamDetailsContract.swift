//
//  TeamDetailsContract.swift
//  Sportify
//
//  Created by Tasneem Hakeem on 13/05/2026.
//

import Foundation
import UIKit

protocol TeamDetailsViewProtocol: AnyObject {
    func showLoading()
    func hideLoading()
    func showError(message: String)
    func reloadData()
    func setTeamName(_ name: String)
    func setTeamLogo(_ url: String?)
}

protocol TeamDetailsPresenterProtocol: AnyObject {
    func viewDidLoad()
    var playersCount: Int { get }
    func getPlayer(at index: Int) -> Player
}

protocol TeamDetailsRouterProtocol: AnyObject { }
