//
//  CharacterListView.swift
//  RickMortyLuscii
//
//  Created by Patrick Rugebregt on 13/07/2025.
//

import SwiftUI

struct CharacterListView: View {
    @StateObject var characterListViewModel: CharacterListViewModel
    @Binding var navigationPath: [NavigationDestination]
    
    init(
        characterIds: [String],
        cartoonNetwork: CartoonNetworkCharacterProtocol,
        navigationPath: Binding<[NavigationDestination]>
    ) {
        self._navigationPath = navigationPath
        _characterListViewModel = StateObject(
            wrappedValue: CharacterListViewModel(
                characterIds: characterIds,
                cartoonNetwork: cartoonNetwork
            )
        )
    }
    
    var body: some View {
        List {
            ForEach(characterListViewModel.characterIds, id: \.self) { id in
                Text("Character ID: " + id)
                    .onTapGesture {
                        Task {
                            await characterListViewModel.fetchCharacterDetails(characterId: id)
                            guard let character = characterListViewModel.selectedCharacter else {
                                return
                            }
                            // Navigate to the characterDetail with the selected character
                            navigationPath.append(.characterDetail(selectedCharacter: character))
                        }
                    }
            }
        }
    }
}

#Preview {
    CharacterListView(characterIds: [], cartoonNetwork: CartoonNetwork(), navigationPath: .constant([]))
}
