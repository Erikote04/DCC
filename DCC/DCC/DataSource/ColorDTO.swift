//
//  ColorDTO.swift
//  DCC
//
//  Created by Erik Sebastian de Erice Jerez on 25/6/25.
//

import SwiftUI

struct ColorDTO: Codable, Identifiable {
    let id: Int
    let collectionId: Int
    let name: String
    let hex: String
    let cmykArray: [Int]
    let rgbArray: [Int]
    let combinations: [Int]

    enum CodingKeys: String, CodingKey {
        case id
        case collectionId = "collection_id"
        case name
        case hex
        case rgbArray = "rgb_array"
        case cmykArray = "cmyk_array"
        case combinations
    }
}
