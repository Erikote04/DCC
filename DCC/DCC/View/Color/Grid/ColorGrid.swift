//
//  ColorGrid.swift
//  DCC
//
//  Created by Erik Sebastian de Erice Jerez on 28/6/25.
//

import SwiftUI

struct ColorGrid: View {
    @EnvironmentObject private var viewModel: ColorCombinationViewModel
    
    let swatch: Swatch
    
    private let minCellWidth: CGFloat = 150
    
    var columns: [GridItem] {
        [GridItem(.adaptive(minimum: minCellWidth), spacing: .zero)]
    }
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: .zero, pinnedViews: .sectionHeaders) {
            Section {
                if let colors = viewModel.colorsBySwatch[swatch.id] {
                    ForEach(colors) { color in
                        NavigationLink(value: color) {
                            GeometryReader { geometry in
                                ColorCell(
                                    color: color,
                                    size: geometry.size.width
                                )
                            }
                            .aspectRatio(1, contentMode: .fit)
                        }
                    }
                    .padding()
                }
            } header: {
                SectionHeader(swatch: swatch)
            }
        }
    }
}
