//
//  SectionHeader.swift
//  DCC
//
//  Created by Erik Sebastian de Erice Jerez on 6/7/25.
//

import SwiftUI

struct SectionHeader: View {
    @Environment(\.colorScheme) private var colorScheme
    
    let swatch: Swatch
    
    var backgroundColor: Color {
        colorScheme == .dark ? .black : .white
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Collection \(swatch.id)")
                .font(.title2)
                
            Text(swatch.description)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(backgroundColor)
    }
}
