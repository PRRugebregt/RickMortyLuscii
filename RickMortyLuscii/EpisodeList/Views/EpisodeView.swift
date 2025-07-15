//
//  EpisodeView.swift
//  testSwiftData
//
//  Created by Patrick Rugebregt on 13/07/2025.
//

import Foundation
import SwiftUI

struct EpisodeView: View {
    let name: String
    let airDate: String
    let episodeCode: String
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(name)
                    .font(.title3)
                    .fontWeight(.bold)
                HStack {
                    Text("Episode nr: " + episodeCode)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Text("Airdate: " + airDate)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundStyle(.black)
        }
    }
}
