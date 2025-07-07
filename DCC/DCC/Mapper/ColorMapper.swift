//
//  ColorMapper.swift
//  DCC
//
//  Created by Erik Sebastian de Erice Jerez on 25/6/25.
//

import SwiftUI

protocol ColorMapperProtocol {
    func map(_ color: ColorDTO) -> ColorModel
    func map(_ colors: [ColorDTO]) -> [ColorModel]
}

struct ColorMapper: ColorMapperProtocol {
    func map(_ color: ColorDTO) -> ColorModel {
        let R = color.rgbArray[0]
        let G = color.rgbArray[1]
        let B = color.rgbArray[2]
        
        let C = color.cmykArray[0]
        let M = color.cmykArray[1]
        let Y = color.cmykArray[2]
        let K = color.cmykArray[3]
        
        return ColorModel(
            id: color.id,
            collectionId: color.collectionId,
            name: color.name,
            color: Color(
                red: Double(R)/255,
                green: Double(G)/255,
                blue: Double(B)/255),
            hex: color.hex,
            cmyk: "CMYK: \(C) \(M) \(Y) \(K)",
            rgb: "RGB: \(R) \(G) \(B)",
            combinations: color.combinations
        )
    }

    func map(_ colors: [ColorDTO]) -> [ColorModel] {
        colors.map(map)
    }
}
