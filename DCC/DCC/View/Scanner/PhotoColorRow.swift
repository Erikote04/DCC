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
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(photoColor.hex)
                .font(.headline)
            
            Text(photoColor.rgb)
                .font(.subheadline)
            
            Text(photoColor.cmyk)
                .font(.subheadline)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .foregroundStyle(photoColor.color.contrastingTextColor())
        .background(photoColor.color)
        .cornerRadius(8)
        .copyFormats(of: photoColor)
    }
}
