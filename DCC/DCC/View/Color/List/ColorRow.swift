//
//  ColorRow.swift
//  DCC
//
//  Created by Erik Sebastian de Erice Jerez on 28/6/25.
//

import SwiftUI

struct ColorRow: View {
    @Environment(\.colorScheme) private var colorScheme
    
    let color: ColorModel
    
    var backgroundColor: Color {
        colorScheme == .dark ? .black : .white
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(color.name)
                .font(.headline)
                .multilineTextAlignment(.leading)
            
            Text(color.hex)
                .font(.subheadline)
                .multilineTextAlignment(.leading)
            
            Text(color.rgb)
                .font(.caption)
                .multilineTextAlignment(.leading)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .foregroundStyle(color.color.contrastingTextColor())
        .background(color.color)
    }
}
