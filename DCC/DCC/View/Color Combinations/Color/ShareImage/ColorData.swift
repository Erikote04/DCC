//
//  ColorData.swift
//  DCC
//
//  Created by Erik Sebastian de Erice Jerez on 9/7/25.
//

import SwiftUI

struct ColorData: View {
    let color: ColorModel
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 16)
                    .fill(color.color)
                    .frame(width: 300, height: 300)
                
                VStack(alignment: .leading) {
                    Text(color.name).font(.title)
                    Text(color.hex).font(.headline)
                    Text(color.rgb).font(.subheadline)
                    Text(color.cmyk).font(.subheadline)
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

#Preview {
    ColorData(color: ColorModel(
        id: 159,
        collectionId: 6,
        name: "Black",
        color: .black,
        hex: "#000000",
        cmyk: "CMYK: 20 10 15 100",
        rgb: "RGB: 0 0 0",
        combinations: [46, 52, 62]
    ))
}
