//
//  FavoriteService.swift
//  Sportify
//
//  Created by Tasneem Hakeem on 10/05/2026.
//

import CoreData
import UIKit

final class FavoritesService: FavoritesServiceProtocol {

    static let shared = FavoritesService()

    private var context: NSManagedObjectContext {
        let app = UIApplication.shared.delegate as! AppDelegate
        return app.persistentContainer.viewContext
    }

    func save(league: League, sport: APISport) {
        guard let key = league.leagueKey,
              !isFavorite(leagueKey: key) else { return }

        let entity = FavoriteLeague(context: context)
        entity.leagueKey = Int32(key)
        entity.leagueName = league.leagueName
        entity.countryName = league.countryName
        entity.leagueImageUrl = league.leagueImageURL
        entity.countryImageUrl = league.countryImageURL
        entity.sport = sport.rawValue

        try? context.save()
    }

    func remove(leagueKey: Int) {
        let request: NSFetchRequest<FavoriteLeague> = FavoriteLeague.fetchRequest()
        request.predicate = NSPredicate(format: "leagueKey == %d", leagueKey)
        let results = (try? context.fetch(request)) ?? []
        results.forEach { context.delete($0) }
        try? context.save()
    }

    func isFavorite(leagueKey: Int) -> Bool {
        let request: NSFetchRequest<FavoriteLeague> = FavoriteLeague.fetchRequest()
        request.predicate = NSPredicate(format: "leagueKey == %d", leagueKey)
        let count = (try? context.count(for: request)) ?? 0
        return count > 0
    }

    func getAllFavorite() -> [FavoriteLeague] {
        let request: NSFetchRequest<FavoriteLeague> = FavoriteLeague.fetchRequest()
        return (try? context.fetch(request)) ?? []
    }
}
