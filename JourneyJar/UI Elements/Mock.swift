//
//  Mock.swift
//  JourneyJar
//
//  Created by Jean-Charles Mourey on 19/05/2024.
//  Copyright © 2024 Apple. All rights reserved.
//

import Foundation
import CloudKit

@MainActor
extension URL {
    struct Mock {
        let thumbnail = URL(string: "https://artworks.thetvdb.com/banners/posters/292174-1_t.jpg")
        let bogus = URL(string: "https://bogus.com")
        let empty = nil as URL?
    }
    static var mock: Mock { Mock() }
}
