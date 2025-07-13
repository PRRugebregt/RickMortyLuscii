//
//  CharacterDetailViewModel.swift
//  RickMortyLuscii
//
//  Created by Patrick Rugebregt on 13/07/2025.
//

import Foundation
import UIKit

struct RickAndMortyCharacterDetail {
    let id: Int
    let name: String
    let status: String
    let species: String
    let originName: String 
    let imageURL: String
    let episodeCount: Int
    var image: UIImage?
    
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
}

final class CharacterDetailViewModel: ObservableObject {
    @Published var selectedCharacter: RickAndMortyCharacterDetail
    let cartoonNetwork: CartoonNetworkImageProtocol
    
    init(selectedCharacter: RickAndMortyCharacter, cartoonNetwork: CartoonNetworkImageProtocol) {
        let rickAndMortyCharacterDetail = RickAndMortyCharacterDetail.mapCharacter(character: selectedCharacter)
        self.selectedCharacter = rickAndMortyCharacterDetail
        self.cartoonNetwork = cartoonNetwork
        fetchHeaderImage()
    }
    
    private func fetchHeaderImage() {
        Task {
            guard let imageData = await cartoonNetwork.fetchHeaderImage(urlString: selectedCharacter.imageURL) else {
                print("### no imagedata")
                return
            }
            guard let image = UIImage(data: imageData) else {
                debugPrint("### Failed to create image from fetched image data")
                return
            }
            
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                self.selectedCharacter.image = image
            }
        }
    }
    
}
