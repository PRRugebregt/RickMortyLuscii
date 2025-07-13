//
//  NetworkError.swift
//  testSwiftData
//
//  Created by Patrick Rugebregt on 13/07/2025.
//

import Foundation

enum NetworkError: Error {
    case generalError(errorMessage: String)
    case emptyResponse
    case decodingError(errorMessage: String)
    case invalidURL
}
