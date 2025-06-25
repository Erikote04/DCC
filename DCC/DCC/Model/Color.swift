//
//  Color.swift
//  DCC
//
//  Created by Erik Sebastian de Erice Jerez on 25/6/25.
//

import SwiftUI

struct Color: Identifiable, Hashable {
    let id: Int
    let name: String
    let color: SwiftUI.Color
    let hex: String
    let combinations: [Int]
    let swatchCollection: Int
}
