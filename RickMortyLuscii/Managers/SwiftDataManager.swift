//
//  SwiftDataManager.swift
//  RickMortyLuscii
//
//  Created by Patrick Rugebregt on 14/07/2025.
//

import Foundation
import SwiftData

protocol SwiftDataManagerProtocol {
    func fetchAllEpisodes() -> [RickAndMortyEpisodePersistence]
    func saveEpisodes(episodes: [RickAndMortyEpisode])
    func removeAllEpisodes()
}

final class SwiftDataManager: SwiftDataManagerProtocol {
    private let mainContext: ModelContext
    
    init(mainContext: ModelContext) {
        self.mainContext = mainContext
    }
    
    func fetchAllEpisodes() -> [RickAndMortyEpisodePersistence] {
        let fetchRequest = FetchDescriptor<RickAndMortyEpisodePersistence>()
        do {
            let savedEpisodes = try mainContext.fetch(fetchRequest)
            return savedEpisodes
        } catch {
            debugPrint("### Error fetching saved episodes in SwiftDatamanager \(error.localizedDescription)")
            return []
        }
    }
    
    func saveEpisodes(episodes: [RickAndMortyEpisode]) {
        // Map to persistence model
        let persistenceEpisodes: [RickAndMortyEpisodePersistence] = episodes.map { .init(from: $0) }
        
        persistenceEpisodes.forEach { persistenceEpisode in
            mainContext.insert(persistenceEpisode)
        }
        do {
            try mainContext.save()
        } catch {
            debugPrint("### Error saving mainContext after inserting data SwiftData \(error.localizedDescription)")
        }
    }
    
    func removeAllEpisodes() {
        let episodesToRemove = fetchAllEpisodes()
        do {
            episodesToRemove.forEach { episode in
                mainContext.delete(episode)
            }
            try mainContext.save()
        } catch {
            debugPrint("### Error saving mainContext after deleting data SwiftData \(error.localizedDescription)")
        }
    }
}
