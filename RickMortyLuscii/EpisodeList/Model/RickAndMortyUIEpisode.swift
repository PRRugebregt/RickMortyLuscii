//
//  RickAndMortyUIModel.swift
//  RickMortyLuscii
//
//  Created by Patrick Rugebregt on 16/07/2025.
//

import Foundation

struct RickAndMortyUIEpisode: Identifiable, Codable {
    let id: Int
    let name: String
    let airDate: String
    let episode: String
    let characters: [String]
    
    init(from rickAndMortyEpisode: RickAndMortyEpisode) {
        self.id = rickAndMortyEpisode.id
        self.name = rickAndMortyEpisode.name
        self.airDate = rickAndMortyEpisode.airDate
        self.episode = rickAndMortyEpisode.episode
        self.characters = rickAndMortyEpisode.characters
    }
    
    init(from rickAndMortyEpisodePersistence: RickAndMortyEpisodePersistence) {
        self.id = rickAndMortyEpisodePersistence.id
        self.name = rickAndMortyEpisodePersistence.name
        self.airDate = rickAndMortyEpisodePersistence.airDate
        self.episode = rickAndMortyEpisodePersistence.episode
        self.characters = rickAndMortyEpisodePersistence.characters
    }
}
