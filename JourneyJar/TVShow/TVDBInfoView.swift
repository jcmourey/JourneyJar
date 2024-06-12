//
//  TVDBInfoView.swift
//  JourneyJar
//
//  Created by Jean-Charles Mourey on 12/06/2024.
//

import SwiftUI

struct TVDBInfoView: View {
    let info: TVDBInfo
    
    var body: some View {
        HStack {
            OptionalText(info.network)
            Spacer()
            OptionalView(info.year) { Text("\($0)") }
        }
        .font(.title)
        
        HStack {
            OptionalText(info.country?.uppercased())
            Spacer()
            OptionalText(info.language?.uppercased())
        }
        .bold()

        
        Thumbnail(url: info.imageURL)
        
        KeyValuePair("score", info.score)
        KeyValuePair("average runtime", info.averageRuntime)
        KeyValuePair("next aired", info.nextAired)

        if let overview = info.overview {
            Text(overview)
                .font(.callout)
        }
    }
}

#Preview {
    TVDBInfoView(info: .mock.hpi)
}
