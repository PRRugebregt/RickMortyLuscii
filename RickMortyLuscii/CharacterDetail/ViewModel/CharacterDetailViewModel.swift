//
//  CharacterDetailViewModel.swift
//  RickMortyLuscii
//
//  Created by Patrick Rugebregt on 13/07/2025.
//

import Foundation
import UIKit

final class CharacterDetailViewModel: ObservableObject {
    @Published var selectedCharacter: RickAndMortyCharacterDetail
    @Published var headerImage: UIImage?
    let cartoonNetwork: CartoonNetworkImageProtocol
    private let fileExporter = FileExporter()
    
    init(
        selectedCharacter: RickAndMortyCharacter,
        cartoonNetwork: CartoonNetworkImageProtocol
    ) {
        // Map to UI model
        let rickAndMortyCharacterDetail = RickAndMortyCharacterDetail.init(from: selectedCharacter)
        self.selectedCharacter = rickAndMortyCharacterDetail
        self.cartoonNetwork = cartoonNetwork
        // Fetch the header image
        fetchHeaderImage()
    }
    
    private func fetchHeaderImage() {
        Task {
            guard let imageData = await cartoonNetwork.fetchHeaderImage(urlString: selectedCharacter.imageURL) else {
                debugPrint("### fetchHeaderImage - no image data")
                return
            }
            guard let image = UIImage(data: imageData) else {
                debugPrint("### fetchHeaderImage - Failed to create image from fetched image data")
                return
            }
            
            DispatchQueue.main.async { [weak self] in
                self?.headerImage = image
            }
        }
    }
    
    func convertModelAndFetchURL() -> URL? {
        fileExporter.encodeModel(
            model: selectedCharacter,
            documentName: selectedCharacter.name
        )
    }
}
