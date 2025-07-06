//
//  TabItem.swift
//  DCC
//
//  Created by Erik Sebastian de Erice Jerez on 6/7/25.
//

import SwiftUI

enum TabItem: String, CaseIterable, Identifiable, Hashable {
    case colors
    case combinations
    
    var id: String { rawValue }
    
    var title: String {
        switch self {
        case .colors: return "Colors"
        case .combinations: return "Combinations"
        }
    }
    
    var image: String {
        switch self {
        case .colors: return "paintpalette.fill"
        case .combinations: return "swatchpalette.fill"
        }
    }
    
    @ViewBuilder
    var body: some View {
        switch self {
        case .colors: ColorsView()
        case .combinations: CombinationsView()
        }
    }
}
