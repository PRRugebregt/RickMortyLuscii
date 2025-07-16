//
//  RickAndMortyCharacterDetail.swift
//  RickMortyLuscii
//
//  Created by Patrick Rugebregt on 13/07/2025.
//

import Foundation

/// Model for characterDetail UI and document export
struct RickAndMortyCharacterDetail: Encodable {
    let id: Int
    let name: String
    let status: String
    let species: String
    let originName: String
    let imageURL: String
    let episodeCount: Int

    // Use codingKeys to omit certain properties in export
    enum CodingKeys: CodingKey {
        case name
        case status
        case species
        case originName
        case episodeCount
    }
    
    init(from character: RickAndMortyCharacter) {
        self.id = character.id
        self.name = character.name
        self.status = character.status
        self.species = character.species
        self.originName = character.origin.name
        self.imageURL = character.image
        self.episodeCount = character.episode.count
    }
}
