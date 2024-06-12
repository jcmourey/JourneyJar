//
//  TheTVDBSeriesSearchModel.swift
//  JourneyJar
//
//  Created by Jean-Charles Mourey on 04/05/2024.
//

import Foundation
import IdentifiedCollections

/// TheTVDB search
/// https://api4.thetvdb.com/v4/search?query=Dark Matter

struct TheTVDBSeriesSearchResult: Codable {
    let data: IdentifiedArrayOf<TheTVDBSeries>
}

struct TheTVDBSeries: Codable {
    let tvdbId: String
    let country: String?
    let name: String
    let type: String
    let year: String?
    let slug: String?
    let network: String?
    let overview: String?
    let imageUrl: URL?
    let thumbnail: URL?
    let primaryLanguage: String?
    let status: String?
}

extension TheTVDBSeries: Identifiable {
    var id: String { tvdbId }
}

extension TheTVDBSeries: Hashable {}
