//
//  ColorCell.swift
//  DCC
//
//  Created by Erik Sebastian de Erice Jerez on 28/6/25.
//

import SwiftUI

struct ColorCell: View {
    let color: ColorModel
    let size: CGFloat
    
    var body: some View {
        ZStack(alignment: .bottom) {
            color.color
            
            VStack(alignment: .leading) {
                Text(color.name)
                    .font(.headline)
                    .foregroundStyle(.black)
                    .multilineTextAlignment(.leading)
                
                Text(color.hex)
                    .font(.subheadline)
                    .foregroundStyle(.gray)
                    .multilineTextAlignment(.leading)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(8)
            .background(.white)
        }
        .frame(width: size, height: size)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.2), radius: 6, x: 2, y: 4)
    }
}
