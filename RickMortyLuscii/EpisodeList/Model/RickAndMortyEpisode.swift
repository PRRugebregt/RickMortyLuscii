//
//  Episode.swift
//  testSwiftData
//
//  Created by Patrick Rugebregt on 09/07/2025.
//

import Foundation

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
