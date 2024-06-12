//
//  FormattingConvenience.swift
//  JourneyJar
//
//  Created by Jean-Charles Mourey on 09/06/2024.
//

import Foundation

extension Date {
    var defaultFormatting: String {
        formatted(date: .abbreviated, time: .shortened)
    }
}
