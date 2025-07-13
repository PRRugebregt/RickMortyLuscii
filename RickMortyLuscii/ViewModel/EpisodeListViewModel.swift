//
//  EpisodeListViewModel.swift
//  testSwiftData
//
//  Created by Patrick Rugebregt on 11/07/2025.
//

import Foundation
import SwiftData

final class EpisodeListViewModel: ObservableObject {
    @Published var episodes: [RickAndMortyEpisode] = []
    @Published var shouldShowEndMessage = false
    private let cartoonNetwork: CartoonNetworkProtocol
    private var episodeModelContext: ModelContext
    private var pageIndex: Int = 1
    private var lastPageIndex: Int = 0

    init(
        episodeModelContext: ModelContext,
        cartoonNetwork: CartoonNetworkProtocol
    ) {
        self.episodeModelContext = episodeModelContext
        self.cartoonNetwork = cartoonNetwork
    }
    
    func fetchNextEpisodePage() {
        // Increment page to fetch the next 20 results
        guard pageIndex < lastPageIndex else {
            return
        }
        pageIndex += 1
        fetchEpisodes()
    }
    
    func fetchEpisodes() {
        Task {
            guard let response = await cartoonNetwork.fetchEpisodes(page: pageIndex) else {
                return
            }
            
            lastPageIndex = response.info.pages
            
            DispatchQueue.main.async { [weak self] in
                guard let self else {
                    return
                }
                // Show user that this was the last result
                if self.lastPageIndex == self.pageIndex {
                    self.shouldShowEndMessage = true
                }
                self.episodes.append(contentsOf: response.results)
            }
        }
    }
    
    func isLastEpisode(_ episode: RickAndMortyEpisode) -> Bool {
        episode.id == episodes.last?.id
    }
}
