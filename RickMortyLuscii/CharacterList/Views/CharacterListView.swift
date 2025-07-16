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
    private let episodeName: String
    private let titleText = "Episode: "
    private let subtitleText = "Characters:"
    private let itemText = "Character ID: "
    
    init(
        characterIds: [String],
        cartoonNetwork: CartoonNetworkCharacterProtocol,
        navigationPath: Binding<[NavigationDestination]>,
        episodeName: String
    ) {
        self._navigationPath = navigationPath
        _characterListViewModel = StateObject(
            wrappedValue: CharacterListViewModel(
                characterIds: characterIds,
                cartoonNetwork: cartoonNetwork
            )
        )
        self.episodeName = episodeName
    }
    
    var body: some View {
        VStack {
            Text(titleText + "\(episodeName)")
                .font(.title)
            Text(subtitleText)
                .font(.title3)
            List {
                ForEach(characterListViewModel.characterIds, id: \.self) { id in
                    Text(itemText + id)
                        .frame(maxWidth: .infinity)
                        .contentShape(Rectangle())
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
}

#Preview {
    CharacterListView(characterIds: [], cartoonNetwork: CartoonNetwork(), navigationPath: .constant([]), episodeName: "Episode")
}
