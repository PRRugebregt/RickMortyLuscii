//
//  Episode.swift
//  testSwiftData
//
//  Created by Patrick Rugebregt on 09/07/2025.
//

import Foundation
import SwiftData

struct RickAndMortyEpisode: Identifiable, Codable {
    let id: Int
    let name: String
    let airDate: String
    let episode: String
    let characters: [String]
    let url: String
    let created: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case airDate = "air_date"
        case episode
        case characters
        case url
        case created
    }
}

@Model
final class RickAndMortyEpisodePersistence {
    let id: Int
    let name: String
    let airDate: String
    let episode: String
    let characters: [RickAndMortyCharacter]
    let url: String
    let created: String
    
    init(
        id: Int,
        name: String,
        airDate: String,
        episode: String,
        characters: [RickAndMortyCharacter],
        url: String,
        created: String
    ) {
        self.id = id
        self.name = name
        self.airDate = airDate
        self.episode = episode
        self.characters = characters
        self.url = url
        self.created = created
    }
}

struct RickAndMortyCharacter: Codable {
    let id: Int // The id of the character.
    let name: String // The name of the character.
    let status: String // The status of the character ('Alive', 'Dead' or 'unknown').
    let species: String // The species of the character.
    let type: String // The type or subspecies of the character.
    let gender: String // The gender of the character ('Female', 'Male', 'Genderless' or 'unknown').
    let origin: Origin // Name and link to the character's origin location.
    let location: Location  // Name and link to the character's last known location endpoint.
    let image: String // Link to the character's image. All images are 300x300px and most are medium shots or portraits since they are intended to be used as avatars.
    let episode: [String] // List of episodes in which this character appeared.
    let url: String // Link to the character's own URL endpoint.
    let created: String  // Time at which the character was created in the database.
}

struct Origin: Codable {
    let name: String
    let url: String
}

struct Location: Codable {
    let name: String
    let url: String
}
