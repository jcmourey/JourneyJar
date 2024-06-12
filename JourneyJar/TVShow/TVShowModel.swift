//
//  TVShowModel.swift
//  JourneyJar
//
//  Created by Jean-Charles Mourey on 08/06/2024.
//

import UIKit
import Tagged
import IdentifiedCollections

struct TVShow: Equatable, Hashable, Identifiable, Codable {
    let id: Tagged<TVShow, UUID>
    var title: String = ""
    let dateAdded: Date
    var dateModified: Date
    
    // info
    var recommendations: IdentifiedArrayOf<Recommendation> = []
    var interest: Interest?
    var progress: Progress?
    var tvdbInfo: TVDBInfo?
}

struct Recommendation: Equatable, Hashable, Identifiable, Codable {
    let id: Tagged<Recommendation, UUID>
    var name = ""
}

struct TVDBInfo: Equatable, Hashable, Identifiable, Codable {
    let tvdbID: Tagged<TVDBInfo, Int>
    var name: String?
    var country: String?
    var year: Int?
    var slug: String?
    var network: String?
    var overview: String?
    var imageURL: URL?
    var language: String?

    // detailed info
    var score: Int?
    var averageRuntime: Int?
    var nextAired: Date?
    
    var id: Tagged<TVDBInfo, Int> { tvdbID }
    
    init(tvdbID: Tagged<TVDBInfo, Int>, name: String? = nil, country: String? = nil, year: Int? = nil, slug: String? = nil, network: String? = nil, overview: String? = nil, imageURL: URL? = nil, language: String? = nil, score: Int? = nil, averageRuntime: Int? = nil, nextAired: Date? = nil) {
        self.tvdbID = tvdbID
        self.name = name
        self.country = country
        self.year = year
        self.slug = slug
        self.network = network
        self.overview = overview
        self.imageURL = imageURL
        self.language = language
        self.score = score
        self.averageRuntime = averageRuntime
        self.nextAired = nextAired
    }
    
    init?(from series: TheTVDBSeries) {
        guard let tvdbID = Int(series.tvdbId) else { return nil }
        let year = if let year = series.year { Int(year) } else { nil as Int? }
        self.init(
            tvdbID: TVDBInfo.ID(tvdbID),
            name: series.name,
            country: series.country,
            year: year,
            slug: series.slug,
            network: series.network,
            overview: series.overview,
            imageURL: series.imageUrl,
            language: series.primaryLanguage
       )
    }
    
    mutating func populate(detail: TheTVDBSeriesDetail) {
        score = detail.score
        averageRuntime = detail.averageRuntime
        nextAired = parseDate(from: detail.nextAired)
    }
}

extension TVShow  {
    enum Progress: String, CaseIterable, RawRepresentable, Codable {
        case notStarted = "not started"
        case watching
        case finished
    }
}
