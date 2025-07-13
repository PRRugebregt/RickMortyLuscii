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
    
    static func mapCharacter(character: RickAndMortyCharacter) -> Self {
        RickAndMortyCharacterDetail(
            id: character.id,
            name: character.name,
            status: character.status,
            species: character.species,
            originName: character.origin.name,
            imageURL: character.image,
            episodeCount: character.episode.count
        )
    }

    // Use codingKeys to omit certain properties in export
    enum CodingKeys: CodingKey {
        case name
        case status
        case species
        case originName
        case episodeCount
    }
}
