//
//  ColorDTO.swift
//  DCC
//
//  Created by Erik Sebastian de Erice Jerez on 25/6/25.
//

import SwiftUI

struct ColorDTO: Codable, Identifiable {
    let id: Int
    let name: String
    let rgbArray: [Int]
    let hex: String
    let combinations: [Int]
    let swatchCollection: Int

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case rgbArray = "rgb_array"
        case hex
        case combinations
        case swatchCollection = "swatch_collection"
    }
}
