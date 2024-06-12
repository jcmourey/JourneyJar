//
//  TheTVDBSeriesDetailModel.swift
//  JourneyJar
//
//  Created by Jean-Charles Mourey on 04/05/2024.
//

import Foundation

/// TheTVDB Series details
/// https://api4.thetvdb.com/v4/series/292174

struct TheTVDBSeriesDetailResult: Codable {
    let data: TheTVDBSeriesDetail
}

struct TheTVDBSeriesDetail: Codable {
    let id: Int
    let name: String?
    let image: URL?
    let firstAired: String?
    let lastAired: String?
    let nextAired: String?
    let score: Int?
    let status: Status?
    let originalCountry: String?
    let originalLanguage: String?
    let overview: String?
    let year: String?
    let averageRuntime: Int?
}

extension TheTVDBSeriesDetail {
    struct Status: Codable, Equatable {
        let id: Int
        let name: String
        let recordType: String
    }
}

extension TheTVDBSeriesDetail: Identifiable, Equatable {}
