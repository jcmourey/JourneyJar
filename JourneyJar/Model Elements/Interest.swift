//
//  Interest.swift
//  JourneyJar
//
//  Created by Jean-Charles Mourey on 26/05/2024.
//  Copyright © 2024 Apple. All rights reserved.
//

import Foundation

enum Interest: Int, CaseIterable, Codable, Comparable {
    case veryLittle
    case casual
    case high
    case absoluteMust    
}

