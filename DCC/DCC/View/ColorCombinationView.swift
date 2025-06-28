//
//  ColorCombinationView.swift
//  DCC
//
//  Created by Erik Sebastian de Erice Jerez on 28/6/25.
//

import SwiftUI

struct ColorCombinationView: View {
    @Environment(\.colorScheme) var colorScheme
    
    private var backgroundColor: SwiftUI.Color {
        colorScheme == .dark ? .black : .white
    }
    
    var body: some View {
        TabView {
            Tab { NavigationStack { ColorsView() }}
            label: { Label("Colors", systemImage: "paintpalette.fill") }
            
            Tab { NavigationStack { CombinationsView() }}
            label: { Label("Combinations", systemImage: "swatchpalette.fill") }
        }
        .tint(.primary)
        .toolbarBackground(backgroundColor, for: .tabBar)
        .toolbarBackground(.visible, for: .tabBar)
    }
}

#Preview {
    ColorCombinationView()
        .environmentObject(ColorCombinationViewModel())
}
