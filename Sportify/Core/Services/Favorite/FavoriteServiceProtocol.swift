//
//  FavoriteServiceProtocol.swift
//  Sportify
//
//  Created by Tasneem Hakeem on 10/05/2026.
//

import Foundation

protocol FavoritesServiceProtocol {
    func save(league: League, sport: APISport)
    func remove(leagueKey: Int)
    func isFavorite(leagueKey: Int) -> Bool
    func getAllFavorite() -> [FavoriteLeague]
}
