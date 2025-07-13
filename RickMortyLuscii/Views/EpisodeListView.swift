//
//  EpisodeListView.swift
//  testSwiftData
//
//  Created by Patrick Rugebregt on 09/07/2025.
//

import SwiftUI
import SwiftData

enum NavigationDestination {
    case episodeList
    case characterList
    case characterDetail
}

struct EpisodeListView: View {
    @StateObject private var episodeListViewModel: EpisodeListViewModel
    @Query private var episodes: [RickAndMortyEpisodePersistence]
    @State private var navigationPath: [NavigationDestination] = []
    
    private let endOfListMessage = "End of the line. There are no more episodes"
    
    init(modelContext: ModelContext) {
        self._episodeListViewModel = StateObject(
            wrappedValue: EpisodeListViewModel(
                episodeModelContext: modelContext,
                cartoonNetwork: CartoonNetwork()
            )
        )
    }

    var body: some View {
        // Note: For larger / hybrid UIKit - SwiftUI apps I would rather use UIHostingControllers and move navigation to UIKit with routers
        NavigationStack(path: $navigationPath) {
            List {
                ForEach(episodeListViewModel.episodes) { episode in
                    EpisodeView(
                        name: episode.name,
                        airDate: episode.airDate,
                        episodeCode: "\(episode.id)"
                    )
                    .onTapGesture {
                        // Navigate to character details
                        navigationPath.append(.characterList)
                    }
                    .onAppear {
                        if episodeListViewModel.isLastEpisode(episode) {
                            // On appearance of the last item, fetch the next page of results
                            episodeListViewModel.fetchNextEpisodePage()
                        }
                    }
                }
                if episodeListViewModel.shouldShowEndMessage {
                    Text(endOfListMessage)
                }
            }
        }
        .onAppear {
            episodeListViewModel.fetchEpisodes()
        }
    }
}

#Preview {
    var sharedModelContainer: ModelContainer = {
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
    return EpisodeListView(modelContext: sharedModelContainer.mainContext)
}
