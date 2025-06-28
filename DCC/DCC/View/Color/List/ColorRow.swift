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
        ZStack(alignment: .bottom) {
            SwiftUI.Color(color.color)
            
            HStack {
                VStack(alignment: .leading) {
                    Text(color.name)
                        .font(.headline)
                        .foregroundStyle(.primary)
                    
                    Text(color.hex)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .foregroundStyle(.secondary)
                    .accessibilityHidden(true)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(backgroundColor)
        }
        .frame(height: 200)
    }
}
