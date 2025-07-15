//
//  RickMortyLusciiApp.swift
//  RickMortyLusciiApp
//
//  Created by Patrick Rugebregt on 09/07/2025.
//

import SwiftUI
import SwiftData

@main
struct RickMortyLusciiApp: App {
    private let sharedModelContainer: ModelContainer = {
        let schema = Schema([
            RickAndMortyEpisodePersistence.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            EpisodeListView(
                cartoonNetwork: CartoonNetwork(), 
                swiftDataManager: SwiftDataManager(sharedModelContainer: sharedModelContainer)
            )
            .modelContext(sharedModelContainer.mainContext)
        }
    }
}
