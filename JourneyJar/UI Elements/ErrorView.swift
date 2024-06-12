//
//  ErrorView.swift
//  JourneyJar
//
//  Created by Jean-Charles Mourey on 23/05/2024.
//  Copyright © 2024 Apple. All rights reserved.
//

import SwiftUI

struct ErrorView: View {
    let errorString: String?
    
    init(_ errorString: String?) {
        self.errorString = errorString
    }
    
    var body: some View {
        if let errorString {
            Text(errorString)
                .font(.caption)
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        ErrorView(nil)
        ErrorView("this is an error")
    }
}
