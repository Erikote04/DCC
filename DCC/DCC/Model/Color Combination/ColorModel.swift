//
//  Color.swift
//  DCC
//
//  Created by Erik Sebastian de Erice Jerez on 25/6/25.
//

import SwiftUI

struct ColorModel: Identifiable, Hashable {
    let id: Int
    let collectionId: Int
    let name: String
    let color: Color
    let hex: String
    let cmyk: String
    let rgb: String
    let combinations: [Int]
}
