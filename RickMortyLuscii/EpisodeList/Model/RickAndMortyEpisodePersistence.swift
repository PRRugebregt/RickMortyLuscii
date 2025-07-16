//
//  RickAndMortyEpisodePersistence.swift
//  RickMortyLuscii
//
//  Created by Patrick Rugebregt on 15/07/2025.
//

import Foundation
import SwiftData

@Model
final class RickAndMortyEpisodePersistence {
    let id: Int
    let name: String
    let airDate: String
    let episode: String
    let characters: [String]
    
    init(
        id: Int,
        name: String,
        airDate: String,
        episode: String,
        characters: [String]
    ) {
        self.id = id
        self.name = name
        self.airDate = airDate
        self.episode = episode
        self.characters = characters
    }
    
    init(from rickAndMortyEpisode: RickAndMortyEpisode) {
        self.id = rickAndMortyEpisode.id
        self.name = rickAndMortyEpisode.name
        self.airDate = rickAndMortyEpisode.airDate
        self.episode = rickAndMortyEpisode.episode
        self.characters = rickAndMortyEpisode.characters
    }
}
