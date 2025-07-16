//
//  FileExporter.swift
//  RickMortyLuscii
//
//  Created by Patrick Rugebregt on 13/07/2025.
//

import Foundation

final class FileExporter {
    func encodeModel<T: Encodable>(model: T, documentName: String? = nil) -> URL? {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        do {
            let data = try encoder.encode(model)
            guard let jsonString = String(data: data, encoding: .utf8) else {
                debugPrint("### Failed to create JSON string")
                return nil
            }
            // Save to temporary folder
            let tempDirectory = FileManager.default.temporaryDirectory
            let documentName = (documentName ?? "MyModelExport") + ".txt"
            let fileURL = tempDirectory.appendingPathComponent(documentName)
            try jsonString.write(to: fileURL, atomically: true, encoding: .utf8)
            // Return URL to export file
            return fileURL
        } catch {
            debugPrint("### Failed to encode model to text \(error.localizedDescription)")
            return nil
        }
    }
}
