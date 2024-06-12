//
//  APIDecoder.swift
//  Lifehacks
//
//  Created by Matteo Manferdini on 16/08/23.
//

import Foundation

extension JSONDecoder {
    static var apiDecoder:  JSONDecoder {
		let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
		return decoder
	}
}

// convert string format "2024-05-23" to a Date
// fails as nil if invalid format
func parseDate(from dateString: String?) -> Date? {
    guard let dateString else { return nil }
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    return dateFormatter.date(from: dateString)
}
