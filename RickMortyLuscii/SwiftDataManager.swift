//
//  SwiftDataManager.swift
//  RickMortyLuscii
//
//  Created by Patrick Rugebregt on 14/07/2025.
//

import Foundation
import SwiftData

protocol SwiftDataManagerProtocol {
    func saveEpisodes(episodes: [RickAndMortyEpisode])
    func removeAllEpisodes(episodesToRemove: [RickAndMortyEpisodePersistence])
}

final class SwiftDataManager: SwiftDataManagerProtocol, Sendable {
    private let sharedModelContainer: ModelContainer
    
    init(sharedModelContainer: ModelContainer) {
        self.sharedModelContainer = sharedModelContainer
    }
    
    func saveEpisodes(episodes: [RickAndMortyEpisode]) {
        // Map to persistence model
        let persistenceEpisodes = mapEpisodesToPersistenceModel(episodes: episodes)

        Task { @MainActor in
            persistenceEpisodes.forEach { persistenceEpisode in
                sharedModelContainer.mainContext.insert(persistenceEpisode)
            }
            do {
                try sharedModelContainer.mainContext.save()
            } catch {
                debugPrint("### Error saving mainContext after inserting data SwiftData \(error.localizedDescription)")
            }
        }
    }
    
    func removeAllEpisodes(episodesToRemove: [RickAndMortyEpisodePersistence]) {
        Task { @MainActor in
            do {
                episodesToRemove.forEach { episode in
                    sharedModelContainer.mainContext.delete(episode)
                }
                try sharedModelContainer.mainContext.save()
            } catch {
                debugPrint("### Error saving mainContext after deleting data SwiftData \(error.localizedDescription)")
            }
        }
    }
    
    private func mapEpisodesToPersistenceModel(episodes: [RickAndMortyEpisode]) -> [RickAndMortyEpisodePersistence] {
        episodes.compactMap { episode in
            .init(
                id: episode.id,
                name: episode.name,
                airDate: episode.airDate,
                episode: episode.episode,
                characters: episode.characters,
                url: episode.url,
                created: episode.created
            )
        }
    }
}
