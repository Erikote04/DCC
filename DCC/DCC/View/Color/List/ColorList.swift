//
//  ColorList.swift
//  DCC
//
//  Created by Erik Sebastian de Erice Jerez on 28/6/25.
//

import SwiftUI

struct ColorList: View {
    @Environment(\.colorScheme) private var colorScheme
    @EnvironmentObject private var viewModel: ColorCombinationViewModel
    
    let swatch: Swatch
    
    var backgroundColor: SwiftUI.Color {
        colorScheme == .dark ? .black : .white
    }
    
    var body: some View {
        LazyVStack(pinnedViews: .sectionHeaders) {
            Section {
                if let colors = viewModel.colorsBySwatch[swatch.id] {
                    ForEach(colors) { color in
                        NavigationLink(value: color) {
                            ColorRow(color: color)
                        }
                    }
                }
            } header: {
                Text("Swatch Collection \(swatch.id)")
                    .font(.title2)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(backgroundColor)
            }
        }
    }
}
