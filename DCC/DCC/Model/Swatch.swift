//
//  Swatch.swift
//  DCC
//
//  Created by Erik Sebastian de Erice Jerez on 25/6/25.
//

import SwiftUI

struct Swatch: Codable, Identifiable {
    let id: Int
    let colorCount: Int

    enum CodingKeys: String, CodingKey {
        case id
        case colorCount = "color_count"
    }
}
