//
//  CartoonNetwork.swift
//  testSwiftData
//
//  Created by Patrick Rugebregt on 13/07/2025.
//

import Foundation

protocol CartoonNetworkProtocol {
    func fetchEpisodes(page: Int) async -> BaseResponse<RickAndMortyEpisode>?
    func fetchLocations() async
    func fetchCharacters() async
}

final class CartoonNetwork: CartoonNetworkProtocol {
    private let urlSession = URLSession.shared
    private let baseUrl = "https://rickandmortyapi.com/api/"
    
    func fetchEpisodes(page: Int) async -> BaseResponse<RickAndMortyEpisode>? {
        let episodesResult: Result<BaseResponse<RickAndMortyEpisode>, NetworkError> = await request(
            urlString: baseUrl + RequestType.episode.rawValue + "/",
            parameters: ["page": "\(page)"]
        )
        
        switch episodesResult {
        case .success(let baseResponse):
            return baseResponse
        case .failure(let error):
            debugPrint("### Error in Api call. /nError type:\(error.self) /nError message: \(error.localizedDescription)")
            return nil
        }
    }
    
    func fetchLocations() async {
        
    }
    
    func fetchCharacters() async {
        
    }
    
    func request<T: Codable>(urlString: String, parameters: [String: String]) async -> Result<T, NetworkError> {
        // Create URL with parameters
        guard let url = createURLWithParameters(parameters, urlString: urlString) else {
            return .failure(.invalidURL)
        }
        print("### URL \(url)")
        let urlRequest = URLRequest(url: url)

        do {
            let (data, response) = try await urlSession.data(for: urlRequest)
            if let httpResponse = response as? HTTPURLResponse {
                debugPrint("### API call statusCode: \(httpResponse.statusCode) for url \(urlString)")
            }
            return decodeResult(data: data)
        } catch {
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
