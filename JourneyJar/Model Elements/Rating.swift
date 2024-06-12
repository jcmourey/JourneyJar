//
//  Rating.swift
//  JourneyJar
//
//  Created by Jean-Charles Mourey on 25/05/2024.
//  Copyright © 2024 Apple. All rights reserved.
//

import SwiftUI

protocol Rating: Comparable, CaseIterable, Hashable where Self.AllCases == Array<Self> {
    static var onSymbol: Symbol { get }
    static var offSymbol: Symbol? { get }
}

extension Rating {
    static var offSymbol: Symbol? { nil }
}

enum Symbol: String {
    case star = "star.fill"
    case heart = "heart.fill"
    
    var color: Color {
        switch self {
        case .star: .yellow
        case .heart: .red
        }
    }
    
    var image: Image { Image(systemName: rawValue) }
}


extension Interest: Rating {
    static var onSymbol: Symbol { .heart }
    
    static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}


enum Stars: Int  {
    case one = 1
    case two
    case three
    case four
    case five
}

extension Stars: Rating {
    static var onSymbol: Symbol { .star }

    static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}
