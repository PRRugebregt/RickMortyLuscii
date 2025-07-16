//
//  CharacterListViewModel.swift
//  RickMortyLuscii
//
//  Created by Patrick Rugebregt on 13/07/2025.
//

import Foundation

final class CharacterListViewModel: ObservableObject {
    @Published var characterIds: [String]
    @Published var selectedCharacter: RickAndMortyCharacter?
    var cartoonNetwork: CartoonNetworkCharacterProtocol
    
    init(
        characterIds: [String],
        cartoonNetwork: CartoonNetworkCharacterProtocol
    ) {
        self.characterIds = characterIds
        self.cartoonNetwork = cartoonNetwork
    }
    
    func fetchCharacterDetails(characterId: String) {
        Task {
            guard let characterDetail = await cartoonNetwork.fetchCharacterDetails(characterId: characterId) else {
                return
            }
            DispatchQueue.main.async { [weak self] in
                self?.selectedCharacter = characterDetail
            }
        }
    }
}
