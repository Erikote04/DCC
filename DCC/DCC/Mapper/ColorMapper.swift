//
//  ColorMapper.swift
//  DCC
//
//  Created by Erik Sebastian de Erice Jerez on 25/6/25.
//

import SwiftUI

protocol ColorMapperProtocol {
    static func map(_ color: ColorDTO) -> Color
    static func map(_ colors: [ColorDTO]) -> [Color]
}

struct ColorMapper: ColorMapperProtocol {
    static func map(_ color: ColorDTO) -> Color {
        return Color(
            id: color.id,
            name: color.name,
            color: SwiftUI.Color(
                red: Double(color.rgbArray[0]) / 255.0,
                green: Double(color.rgbArray[1]) / 255.0,
                blue: Double(color.rgbArray[2]) / 255.0
            ),
            hex: color.hex,
            combinations: color.combinations,
            swatchCollection: color.swatchCollection
        )
    }

    static func map(_ colors: [ColorDTO]) -> [Color] {
        colors.map(map)
    }
}
