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
    case scan
    
    var id: String { rawValue }
    
    var title: String {
        switch self {
        case .colors: return "Colors"
        case .combinations: return "Combinations"
        case .scan: return "Scanner"
        }
    }
    
    var image: String {
        switch self {
        case .colors: return "paintpalette.fill"
        case .combinations: return "swatchpalette.fill"
        case .scan: return "camera"
        }
    }
    
    @ViewBuilder
    var body: some View {
        switch self {
        case .colors: ColorsView()
        case .combinations: CombinationsView()
        case .scan: PhotoColorPickerView()
        }
    }
}
