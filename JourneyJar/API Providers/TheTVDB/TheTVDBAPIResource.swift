//
//  TheTVDBAPIResource.swift
//  JourneyJar
//
//  Created by Jean-Charles Mourey on 04/05/2024.
//

import Foundation

protocol TheTVDBAPIResource: APIResource {
    var token: String { get }
}

extension TheTVDBAPIResource {
    //    var basePath: String { "https://api.thetvdb.com/" }
    var basePath: String { "https://api4.thetvdb.com/v4/" }
    
    var apiKey: String { "7d28eed8-32c0-42ea-8295-31395ddc41a5" }
    
    // token must be renewed every month
    var token: String {
        "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhZ2UiOiIiLCJhcGlrZXkiOiI1ODBjOTIzOS1kMmY4LTQ0NjAtYTIyZS02ODMxOTAwYTk3YTMiLCJjb21tdW5pdHlfc3VwcG9ydGVkIjp0cnVlLCJleHAiOjE3MjA0Njc0ODksImdlbmRlciI6IiIsImhpdHNfcGVyX2RheSI6MTAwMDAwMDAwLCJoaXRzX3Blcl9tb250aCI6MTAwMDAwMDAwLCJpZCI6IjEiLCJpc19tb2QiOnRydWUsImlzX3N5c3RlbV9rZXkiOmZhbHNlLCJpc190cnVzdGVkIjpmYWxzZSwicGluIjoiSVBRWk9DTU4iLCJyb2xlcyI6WyJNb2QiXSwidGVuYW50IjoidHZkYiIsInV1aWQiOiIifQ.etT83F2K6MD1cRQ_YGilmyCETNgupOmMPN4CnmIDhXGILAeKOYcmfxMO6MdjfLmFMhUe1cML8JaRwEN-zh7kVsTqAkhzXyu95kV8eCksk2XcPymabULMlWtoxihcqk1Qu0v6o6GLmSTzszFdlpGc0KacOqYkYl4iwucClZ-q29CjZBfgMkvSjVpe71vFi6nkJfJ4xXqk6ieyYhkjAEH9Y12B4ucYtxQ9UNUL1pNpj77skprXuMmEDB1Wm_LKBEndOU15wXZDIM_SD0_CZjLMUGQFLL-1qSpQ7x2cvPN1was6UJofHoOXfCe8fWRVJN8mEwfuNrBCWFLIyupDpTYIYpX3TdMNt3QMrrisTnyxlTD7LIr9cvXrzFvc0ju-08E8V8gyZE71EROE4GdSJv5jis2nBtgQZD3hADN5DlZunSa12d4Trbfv2w0vgToPt7_2Tx02Bze0kJ5qsltg9LBB96gSAuFMzVt8-24LrzmaTrra_NZzqzzYxpCRx-kYsVUUnrBGk0LmcPBkydMQrB7X48RFI0ZghzPotIagTtgBfI8yDBeJ_6nANCFQCkoujfJXvKl1hgxKq4nLPd1LOvqczyNndXkJQIJRFyGVaGr5bsZmJ56u4hv4o0655dUZdea1p-5lu0E0u3DE9_yh9hTBzYFpfQnLyu92u7IDTQlSeZA"
    }
    
    var headers: [String: String] {
        ["Authorization": "Bearer \(token)"]
    }
}

struct TheTVDBSeriesSearchResource: TheTVDBAPIResource {
    typealias ModelType = TheTVDBSeriesSearchResult
    
    static let baseUserURL = URL(string: "https://www.thetvdb.com/series")!

    let searchQuery: String
    
    var method: String { "search" }
    
    var queryItems: [URLQueryItem] {
        [
            URLQueryItem(name: "query", value: searchQuery),
            URLQueryItem(name: "type", value: "series")
        ]
    }
}

struct TheTVDBSeriesDetailResource: TheTVDBAPIResource {
    typealias ModelType = TheTVDBSeriesDetailResult
    let tvdbID: Int
    var method: String { "series/\(tvdbID)" }
}

struct TheTVDBSeriesExtendedResource: TheTVDBAPIResource {
    typealias ModelType = TheTVDBSeriesExtendedResult
    let tvdbID: Int
    var method: String { "series/\(tvdbID)/extended" }
}

