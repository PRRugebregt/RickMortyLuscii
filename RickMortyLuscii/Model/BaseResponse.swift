//
//  BaseResponse.swift
//  testSwiftData
//
//  Created by Patrick Rugebregt on 13/07/2025.
//

import Foundation

struct BaseResponse<T: Codable>: Codable {
    let info: BaseInfo
    let results: [T]
}

struct BaseInfo: Codable {
    let count: Int
    let pages: Int
    let next: String?
    let prev: String?
}
