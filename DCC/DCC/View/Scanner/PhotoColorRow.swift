//
//  PhotoColorRow.swift
//  DCC
//
//  Created by Erik Sebastian de Erice Jerez on 13/11/25.
//

import SwiftUI

struct PhotoColorRow: View {
    @Environment(\.colorScheme) private var colorScheme
    
    let photoColor: PhotoColor
    let showPercentage: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                if showPercentage {
                    Text(String(format: "%.1f%%", photoColor.percentage))
                        .font(.headline)
                } else {
                    Text("Selected")
                        .font(.headline)
                }
                Spacer()
            }
            
            Text(photoColor.hex)
                .font(.subheadline.bold())
            
            Text(photoColor.rgb)
                .font(.caption)
            
            Text(photoColor.cmyk)
                .font(.caption)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .foregroundStyle(photoColor.color.contrastingTextColor())
        .background(photoColor.color)
        .cornerRadius(8)
        .copyFormats(of: photoColor)
    }
}
