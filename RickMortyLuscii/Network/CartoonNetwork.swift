//
//  CartoonNetwork.swift
//  testSwiftData
//
//  Created by Patrick Rugebregt on 13/07/2025.
//

import Foundation

protocol CartoonNetworkEpisodeProtocol {
    func fetchEpisodes(page: Int) async -> BaseResponse<RickAndMortyEpisode>?
}

protocol CartoonNetworkCharacterProtocol {
    func fetchCharacterDetails(characterId: String) async -> RickAndMortyCharacter?
}

final class CartoonNetwork: CartoonNetworkEpisodeProtocol {
    private let urlSession = URLSession.shared
    private let baseUrl = "https://rickandmortyapi.com/api/"
    
    func fetchEpisodes(page: Int) async -> BaseResponse<RickAndMortyEpisode>? {
        let urlString = baseUrl + RequestType.episode.rawValue
        guard let url = createURLWithParameters(["page": "\(page)"], urlString: urlString) else {
            debugPrint("### Error fetching episodes. Invalid URL")
            return nil
        }
        
        let episodesResult: Result<BaseResponse<RickAndMortyEpisode>, NetworkError> = await request(
            url: url
        )
        
        switch episodesResult {
        case .success(let baseResponse):
            return baseResponse
        case .failure(let error):
            return nil
        }
    }
    
    func request<T: Codable>(url: URL) async -> Result<T, NetworkError> {
        let urlRequest = URLRequest(url: url)

        do {
            let (data, response) = try await urlSession.data(for: urlRequest)
            if let httpResponse = response as? HTTPURLResponse {
                debugPrint("### API call statusCode: \(httpResponse.statusCode) for url \(url.absoluteString)")
            }
            return decodeResult(data: data)
        } catch {
            debugPrint("### Error in Api call. /nError type:\(error.self) /nError message: \(error.localizedDescription)")
            return .failure(.generalError(errorMessage: error.localizedDescription))
        }
    }
    
    private func createURLWithParameters(_ parameters: [String: String], urlString: String) -> URL? {
        guard var urlComponents = URLComponents(string: urlString) else {
            return nil
        }
        // Add parameters to URL
        urlComponents.queryItems = parameters.map({ URLQueryItem(name: $0.key, value: $0.value) })
        // Return optional URL
        return urlComponents.url
    }
    
    private func decodeResult<T: Codable>(data: Data) -> Result<T, NetworkError> {
        let jsonDecoder = JSONDecoder()
        do {
            let result = try jsonDecoder.decode(T.self, from: data)
            return .success(result)
        } catch {
            return .failure(.decodingError(errorMessage: error.localizedDescription))
        }
    }
}

extension CartoonNetwork: CartoonNetworkCharacterProtocol {
    func fetchCharacterDetails(characterId: String) async -> RickAndMortyCharacter? {
        let urlString = baseUrl + RequestType.character.rawValue
        // Create URL with parameters
        guard let url = URL(string: urlString)?.appendingPathComponent(characterId) else {
            debugPrint("### Error creating character URL")
            return nil
        }
        debugPrint("### Created character URL \(url)")
        let characterDetailsResponse: Result<RickAndMortyCharacter, NetworkError> = await request(
            url: url
        )
        switch characterDetailsResponse {
        case .success(let result):
            return result
        case .failure(let error):
            return nil
        }
    }
}
