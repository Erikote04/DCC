//
//  ColorRow.swift
//  DCC
//
//  Created by Erik Sebastian de Erice Jerez on 28/6/25.
//

import SwiftUI

struct ColorRow: View {
    @Environment(\.colorScheme) private var colorScheme
    
    let color: Color
    
    var backgroundColor: SwiftUI.Color {
        colorScheme == .dark ? .black : .white
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(color.name)
                .font(.headline)
            
            Text(color.hex)
                .font(.subheadline)
            
            Text(color.rgb)
                .font(.caption)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .foregroundStyle(color.color.contrastingTextColor())
        .background(color.color)
    }
}
