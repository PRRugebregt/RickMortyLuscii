//
//  RickAndMortyCharacter.swift
//  RickMortyLuscii
//
//  Created by Patrick Rugebregt on 15/07/2025.
//

import Foundation

struct RickAndMortyCharacter: Codable, Hashable {
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

struct Origin: Codable, Hashable {
    let name: String
    let url: String
}

struct Location: Codable, Hashable {
    let name: String
    let url: String
}
