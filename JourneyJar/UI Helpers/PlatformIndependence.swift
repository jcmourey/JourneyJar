//
//  PlatformIndependence.swift
//  JourneyJar
//
//  Created by Jean-Charles Mourey on 17/05/2024.
//  Copyright © 2024 Apple. All rights reserved.
//

import SwiftUI

extension DefaultPickerStyle {
    #if os(watchOS)
    static let segmentedIfAvailable = DefaultPickerStyle.automatic
    #else
    static let segmentedIfAvailable = SegmentedPickerStyle.segmented
    #endif
}

struct Layout {
    static let sheetIdealWidth = 400.0
    static let sheetIdealHeight = 500.0
    
    #if os(macOS)
    static let sectionHeaderPadding: Edge.Set = [.leading]
    #else
    static let sectionHeaderPadding: Edge.Set = []
    #endif
    
    #if os(watchOS)
    static let gridItemSize = CGSize(width: 168, height: 148)
    #else
    static let gridItemSize = CGSize(width: 100, height: 100)
    #endif
    
    static let gridItems = [GridItem(.adaptive(minimum: gridItemSize.width), spacing: 10, alignment: .top)]
    
    #if os(watchOS)
    static let iconSize = 80.0
    #else
    static let iconSize = 60.0
    #endif
    
    static let iconGridItems =  [GridItem(.adaptive(minimum: iconSize), spacing: 10, alignment: .top)]
}
//
#if os(watchOS) || os(macOS) || os(tvOS)
typealias EditButton = EmptyView
#endif

#if os(macOS)
extension ListStyle where Self == InsetListStyle {
    static var clearRowShape: InsetListStyle {
        InsetListStyle(alternatesRowBackgrounds: true)
    }
}
#else
extension ListStyle where Self == PlainListStyle {
    static var clearRowShape: PlainListStyle {
        PlainListStyle()
    }
}
#endif

extension ToolbarItemPlacement {
    #if os(iOS)
    static let firstItem = navigationBarTrailing
    static let secondItem = bottomBar
    #else
    static let firstItem = automatic
    static let secondItem = automatic
    #endif
}

/**
 A  button label with the appropriate style for a toolbar item in a sheet.
 */
struct SheetToolbarItemLabel: View {
    let title: String
    let systemImage: String
    
    var body: some View {
        #if os(macOS)
        Label(title, systemImage: systemImage)
            .labelStyle(.titleOnly)
        #else
        Label(title, systemImage: systemImage)
            .labelStyle(.iconOnly)
        #endif
    }
}


/**
 A text field that has a clear button for watchOS.
 */
struct ClearableTextField: View {
    let title: String
    @Binding var text: String

    var body: some View {
        #if os(watchOS)
        ZStack(alignment: .leading) {
            GeometryReader { geometry in
                TextFieldLink(text.isEmpty ? title: text) { userInput in
                    text = userInput
                }
                .foregroundColor(.secondary)
                .frame(width: geometry.size.width, height: geometry.size.height)
                .buttonStyle(.borderless)
                
                Button(action: {
                    text = ""
                }) {
                    Image(systemName: "xmark")
                        .frame(width: 30, height: geometry.size.height)
                }
                .buttonStyle(.borderless)
                .opacity(text.isEmpty ? 0 : 1)
            }
        }
        #else
        TextField(title, text: $text)
        #endif
    }
}
