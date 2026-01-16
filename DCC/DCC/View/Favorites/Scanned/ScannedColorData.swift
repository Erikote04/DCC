//
//  ScannedColorData.swift
//  DCC
//
//  Created by Erik Sebastian de Erice Jerez on 16/1/26.
//

import SwiftUI

struct ScannedColorData: View {
    let photoColorData: PhotoColorData
    
    private var color: Color {
        Color(hex: photoColorData.hex) ?? .gray
    }
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 16)
                    .fill(color)
                    .frame(width: 300, height: 300)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(photoColorData.hex)
                        .font(.title)
                    
                    Text(photoColorData.rgb)
                        .font(.subheadline)
                    
                    Text(photoColorData.cmyk)
                        .font(.subheadline)
                    
                    if photoColorData.percentage > 0 {
                        Text(String(format: "%.1f%%", photoColorData.percentage))
                            .font(.subheadline)
                    }
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(.white)
                    .shadow(radius: 8)
            )
        }
    }
}
