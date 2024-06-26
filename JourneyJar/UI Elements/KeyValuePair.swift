//
//  KeyValuePairView.swift
//  JourneyJar
//
//  Created by Jean-Charles Mourey on 19/05/2024.
//  Copyright © 2024 Apple. All rights reserved.
//
import ComposableArchitecture
import SwiftUI

struct KeyValuePair: View {
    let key: String
    let value: String
        
    init(_ key: String, _ value: (any StringProtocol)?) {
        self.key = key
        if let value {
            self.value = String(value)
        } else {
            self.value = "<not set>"
        }
    }
    
    init(_ key: String, _ value: (CustomStringConvertible)?) {
        self.init(key, value?.description)
    }
    
    init(_ key: String, _ date: Date?) {
        self.init(key, date?.defaultFormatting)
    }
    
    init(_ key: String, _ number: (any BinaryInteger)?) {
        self.init(key, number?.formatted())
    }
    
    init(_ key: String, _ number: (any BinaryFloatingPoint)?) {
        self.init(key, number?.formatted())
    }

    init<Value: RawRepresentable>(_ key: String, _ value: Value?) where Value.RawValue: StringProtocol {
        self.init(key, value?.rawValue)
    }
    
    init<Value: RawRepresentable>(_ key: String, _ value: Value?) where Value.RawValue: BinaryInteger {
        self.init(key, value?.rawValue)
    }

    var body: some View {
        HStack {
            Text(key)
            Spacer()
            Text(value)
        }
    }
}

struct KeyContentPair<Content: View>: View {
    let key: String
    let content: () -> Content
    let axis: Axis
    
    init(_ key: String, axis: Axis = .horizontal, @ViewBuilder content: @escaping () -> Content) {
        self.key = key
        self.axis = axis
        self.content = content
    }
    
    var body: some View {
        WithPerceptionTracking {
            switch axis {
            case .vertical:
                VStack(alignment: .leading) {
                    Text(key)
                    content()
                }
            case .horizontal:
                HStack {
                    Text(key)
                    Spacer()
                    content()
                }
            }
        }
    }
}

#Preview {
    Form {
        KeyValuePair("String", "some text")
        KeyValuePair("Date", .now)
        KeyValuePair("BinaryInteger", 45340)
        KeyValuePair("BinaryFloatingPoint", 34.567 as (any BinaryFloatingPoint)?)
        KeyValuePair("BinaryFloatingPoint as CustomStringConvertible", 34.567 as CustomStringConvertible?)
        KeyValuePair("Progress", TVShow.Progress.finished)
        KeyValuePair("Interest", Interest.high)
        KeyValuePair("No Progress", nil as TVShow.Progress?)
        KeyValuePair("No Date", nil as Date?)
        KeyValuePair("No Integer", nil as Int?)
        KeyValuePair("No Double", nil as (any BinaryFloatingPoint)?)
        
        KeyContentPair("Stars") {
            RatingView(level: .constant(Interest.high), changeable: false)
        }
    }
}
