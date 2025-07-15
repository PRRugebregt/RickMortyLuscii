//
//  DateHelper.swift
//  RickMortyLuscii
//
//  Created by Patrick Rugebregt on 13/07/2025.
//

import Foundation

final class DateHelper {
    static let shared = DateHelper()
    
    private let apiDateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy"
        formatter.locale = Locale(identifier: "en_us")
        return formatter
    }()
    
    private let dateHourFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM, HH:mm"
        return formatter
    }()
    
    private let dateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MM yyyy"
        return formatter
    }()
    
    func formatToHour(date: Date) -> String {
        dateHourFormatter.string(from: date)
    }
    
    func formatToEpisodeDate(date: String) -> String {
        guard let dateObject = apiDateFormatter.date(from: date) else {
            return ""
        }
        
        return dateFormatter.string(from: dateObject)
    }
}
