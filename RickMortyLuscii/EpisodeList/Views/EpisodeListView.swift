//
//  EpisodeListView.swift
//  testSwiftData
//
//  Created by Patrick Rugebregt on 09/07/2025.
//

import SwiftUI
import SwiftData

enum NavigationDestination: Hashable {
    case episodeList
    case characterList
    case characterDetail(selectedCharacter: RickAndMortyCharacter)
}

// Rootview
struct EpisodeListView: View {
    typealias CartoonNetworkProtocol = CartoonNetworkEpisodeProtocol & CartoonNetworkCharacterProtocol & CartoonNetworkImageProtocol

    private let cartoonNetwork: CartoonNetworkProtocol
    @StateObject private var episodeListViewModel: EpisodeListViewModel

    // Navigation path for SwiftUI navigation
    @State private var navigationPath: [NavigationDestination] = []
    // SwiftData model for persistence
    @Query private var savedEpisodes: [RickAndMortyEpisodePersistence]
    
    private let endOfListMessage = "End of the line. There are no more episodes"
    
    init(
        cartoonNetwork: CartoonNetworkProtocol,
        swiftDataManager: SwiftDataManagerProtocol
    ) {
        self.cartoonNetwork = cartoonNetwork
        self._episodeListViewModel = StateObject(
            wrappedValue: EpisodeListViewModel(
                cartoonNetwork: cartoonNetwork, 
                swiftDataManager: swiftDataManager
            )
        )
    }

    var body: some View {
        NavigationStack(path: $navigationPath) {
            List {
                Text("Last refresh: \(episodeListViewModel.lastRefreshDate)")
                ForEach(episodeListViewModel.episodes) { episode in
                    EpisodeView(
                        name: episode.name,
                        airDate: episodeListViewModel.formatToEpisodeDate(dateString: episode.airDate),
                        episodeCode: "\(episode.id)"
                    )
                    .onTapGesture {
                        episodeListViewModel.selectedEpisodeId = episode.id
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
            .refreshable {
                episodeListViewModel.refreshList(episodesToRemove: savedEpisodes)
            }
            .navigationDestination(for: NavigationDestination.self, destination: { destination in
                switch destination {
                case .characterList:
                    CharacterListView(
                        characterIds: episodeListViewModel.mapCharacterIds(),
                        cartoonNetwork: cartoonNetwork,
                        navigationPath: $navigationPath
                    )
                case .characterDetail(let character):
                    CharacterDetailView(
                        selectedCharacter: character,
                        cartoonNetwork: cartoonNetwork
                    )
                default:
                    Text("Episode not found")
                }
            })
        }
        .onAppear {
            // Check if there are any saved episodes and put them in memory
            guard savedEpisodes.isEmpty else {
                debugPrint("### Found episodes in persistent storage. Number of episodes \(savedEpisodes.count)")
                episodeListViewModel.loadSavedObjects(savedEpisodes: savedEpisodes)
                return
            }
            
            // Else fetch episodes from API
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
    return EpisodeListView(cartoonNetwork: CartoonNetwork(), swiftDataManager: SwiftDataManager(sharedModelContainer: sharedModelContainer))
}
