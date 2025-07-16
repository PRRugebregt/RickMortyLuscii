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
    
    private let endOfListMessage = "End of the line. There are no more episodes"
    private let titleText = "All episodes"
    private let refreshText = "Last refresh: "
    
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
            VStack {
                Text(titleText)
                    .font(.title)
                List {
                    Text(refreshText + "\(episodeListViewModel.lastRefreshDate)")
                    ForEach(episodeListViewModel.episodes) { episode in
                        EpisodeView(
                            name: episode.name,
                            airDate: episodeListViewModel.formatToEpisodeDate(
                                dateString: episode.airDate
                            ),
                            episodeCode: "\(episode.id)"
                        )
                        .contentShape(Rectangle())
                        .onTapGesture {
                            episodeListViewModel.selectedEpisodeId = episode.id
                            // Navigate to character list of IDs
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
                    episodeListViewModel.refreshList()
                }
                .navigationDestination(for: NavigationDestination.self, destination: { destination in
                    determineNextView(destination: destination)
                })
            }
        }
        .onAppear {
            // Check if there are any saved episodes and put them in memory
            episodeListViewModel.checkForSavedEpisodes()
        }
    }
    
    @ViewBuilder
    private func determineNextView(destination: NavigationDestination) -> some View {
        switch destination {
        case .characterList:
            CharacterListView(
                characterIds: episodeListViewModel.mapCharacterIds(),
                cartoonNetwork: cartoonNetwork,
                navigationPath: $navigationPath,
                episodeName: episodeListViewModel.fetchEpisodeName()
            )
        case .characterDetail(let character):
            CharacterDetailView(
                selectedCharacter: character,
                cartoonNetwork: cartoonNetwork
            )
        default:
            Text("Episode not found")
        }
    }
}
