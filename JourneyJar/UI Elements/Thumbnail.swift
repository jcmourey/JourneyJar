//
//  Thumbnail.swift
//  JourneyJar
//
//  Created by Jean-Charles Mourey on 19/05/2024.
//  Copyright © 2024 Apple. All rights reserved.
//

import SwiftUI

struct Thumbnail: View {
    let url: URL?
    var altText: String?
    var showError: Bool = true
    
    @ViewBuilder
    var errorView: some View {
        ContentUnavailableView {
            Label("No image", systemImage: "eye.slash")
        }
    }
        
    var body: some View {
        AsyncImage(url: url) { phase in
            if let image = phase.image {
                ImageView(image)
            } else if phase.error != nil || url == nil {
                if showError {
                    errorView
                }
                if let altText {
                    Text(altText)
                        .frame(maxHeight: .infinity, alignment: .bottom)
                }
            } else {
                ProgressView()
            }
        }
    }
}


#Preview {
    ScrollView {
        LazyVGrid(columns: Layout.gridItems) {
            Thumbnail(url: .mock.thumbnail)
            Thumbnail(url: .mock.empty, showError: false)
            Thumbnail(url: .mock.bogus)
            Thumbnail(url: .mock.empty, altText: "altText")
        }
    }
    .padding()
}
