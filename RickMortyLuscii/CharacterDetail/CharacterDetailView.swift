//
//  CharacterDetailView.swift
//  RickMortyLuscii
//
//  Created by Patrick Rugebregt on 13/07/2025.
//

import SwiftUI

struct CharacterDetailView: View {
    @StateObject var characterDetailViewModel: CharacterDetailViewModel

    init(
        selectedCharacter: RickAndMortyCharacter,
        cartoonNetwork: CartoonNetworkImageProtocol
    ) {
        _characterDetailViewModel = StateObject(
            wrappedValue: CharacterDetailViewModel(
                selectedCharacter: selectedCharacter,
                cartoonNetwork: cartoonNetwork
            )
        )
    }
    
    var body: some View {
        VStack {
            if let image = characterDetailViewModel.selectedCharacter.image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 300, height: 300)
            } else {
                ZStack {
                    Rectangle()
                        .foregroundStyle(.gray)
                        .frame(width: 300, height: 300)
                    ProgressView()
                }
            }
            Spacer()
            VStack(alignment: .leading) {
                HorizontalTextView(leadingText: "Name",trailingText: characterDetailViewModel.selectedCharacter.name)
                    .font(.title)
                HorizontalTextView(leadingText: "Status",trailingText: characterDetailViewModel.selectedCharacter.status)
                HorizontalTextView(leadingText: "Species",trailingText: characterDetailViewModel.selectedCharacter.species)
                HorizontalTextView(leadingText: "Origin",trailingText: characterDetailViewModel.selectedCharacter.originName)
                HorizontalTextView(leadingText: "Episode count",trailingText: "\(characterDetailViewModel.selectedCharacter.episodeCount)")

            }
        }
    }
}

struct HorizontalTextView: View {
    var leadingText: String
    var trailingText: String
    
    var body: some View {
        HStack {
            Text(leadingText + ":")
            Spacer()
            Text(trailingText)
        }
        .padding()
    }
}

#Preview {
    CharacterDetailView(selectedCharacter: .init(id: 0, name: "Rick", status: "Alive", species: "Human", type: "", gender: "Male", origin: .init(name: "", url: ""), location: .init(name: "", url: ""), image: "", episode: [], url: "", created: ""), cartoonNetwork: CartoonNetwork())
}
