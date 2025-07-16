//
//  EpisodeListViewModel.swift
//  testSwiftData
//
//  Created by Patrick Rugebregt on 11/07/2025.
//

import Foundation
import SwiftData
import SwiftUI

final class EpisodeListViewModel: ObservableObject {
    @Published var episodes: [RickAndMortyUIEpisode] = []
    @Published var shouldShowEndMessage = false
    @Published var lastRefreshDate: String = {
        // Fetch the last refresh from UserDefaults
        guard let lastRefresh = UserDefaults.standard.string(forKey: UserDefaultsKeys.lastRefresh) else {
            return ""
        }
        
        return lastRefresh
    }()
    private var lastPageIndex: Int = {
        // When nothing is saved this returns 0
        // lastPageIndex will be updated with the first API call
        UserDefaults.standard.integer(forKey: UserDefaultsKeys.lastPageIndex)
    }()

    
    private let cartoonNetwork: CartoonNetworkEpisodeProtocol
    private let swiftDataManager: SwiftDataManagerProtocol
    private let userDefaults = UserDefaults.standard
    
    private var pageIndex: Int = 1
    // The episode that the user has tapped on
    var selectedEpisodeId: Int = -1

    init(
        cartoonNetwork: CartoonNetworkEpisodeProtocol,
        swiftDataManager: SwiftDataManagerProtocol
    ) {
        self.cartoonNetwork = cartoonNetwork
        self.swiftDataManager = swiftDataManager
    }
    
    func fetchNextEpisodePage() {
        // Increment page to fetch the next 20 results
        guard pageIndex < lastPageIndex else {
            return
        }
        pageIndex += 1
        fetchEpisodes()
    }
    
    func loadSavedObjects(savedEpisodes: [RickAndMortyEpisodePersistence]) {
        // Map to UI model
        DispatchQueue.main.async { [weak self] in
            self?.episodes = savedEpisodes
                .map({ .init(from: $0) })
                .sorted(by: { $0.id < $1.id })
        }
        // Update pageIndex to the number of saved pages of episodes
        // Round the number up (40 episodes = page 2, 41 episodes = page 3)
        pageIndex = (savedEpisodes.count + 20 - 1) / 20
        // Update end message
        shouldShowEndMessage = lastPageIndex == pageIndex
    }
    
    func checkForSavedEpisodes() {
        let savedEpisodes = swiftDataManager.fetchAllEpisodes()
        // If nothing is stored, fetch episodes from the API
        guard !savedEpisodes.isEmpty else {
            fetchEpisodes()
            return
        }
        
        loadSavedObjects(savedEpisodes: savedEpisodes)
    }
    
    func fetchEpisodes() {
        Task {
            guard let response = await cartoonNetwork.fetchEpisodes(page: pageIndex) else {
                return
            }
            
            lastPageIndex = response.info.pages
            saveLastPageIndex()
            
            DispatchQueue.main.async { [weak self] in
                guard let self else {
                    return
                }
                // Show user that this was the last result
                self.shouldShowEndMessage = self.lastPageIndex == self.pageIndex
                // Map to UI model
                let episodes: [RickAndMortyUIEpisode] = response.results.map { .init(from: $0) }
                // Append to the array
                self.episodes.append(contentsOf: episodes)
                // Save to persistent storage
                self.swiftDataManager.saveEpisodes(episodes: response.results)
            }
        }
    }
    
    func refreshList() {
        // Reset all data to sync with API
        DispatchQueue.main.async {
            self.episodes = []
        }
        pageIndex = 1

        // Delete all episodes in persistent storage
        swiftDataManager.removeAllEpisodes()
        
        // Update last refresh date
        let dateString = DateHelper.shared.formatToHour(date: Date())
        userDefaults.set(dateString, forKey: UserDefaultsKeys.lastRefresh)
        lastRefreshDate = dateString
        
        fetchEpisodes()
    }
    
    func formatToEpisodeDate(dateString: String) -> String {
        DateHelper.shared.formatToEpisodeDate(date: dateString)
    }
    
    func isLastEpisode(_ episode: RickAndMortyUIEpisode) -> Bool {
        return episode.id == episodes.last?.id
    }
    
    func mapCharacterIds() -> [String] {
        // Take the character URL (string)
        // Separate by "/" and fetch the last component which is the ID of the character
        // Cast that to a String
        guard let episode = episodes.first(where: { $0.id == selectedEpisodeId }) else {
            return []
        }
        return episode.characters.compactMap { urlString in
            urlString
                .components(separatedBy: "/")
                .last
        }
    }
    
    func fetchEpisodeName() -> String {
        guard let episode = episodes.first(where: { $0.id == selectedEpisodeId }) else {
            return ""
        }
        return episode.name
    }
    
    private func saveLastPageIndex() {
        userDefaults.setValue(lastPageIndex, forKey: UserDefaultsKeys.lastPageIndex)
    }
}
