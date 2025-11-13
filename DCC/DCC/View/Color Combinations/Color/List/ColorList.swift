//
//  ColorList.swift
//  DCC
//
//  Created by Erik Sebastian de Erice Jerez on 28/6/25.
//

import SwiftUI

struct ColorList: View {
    @Environment(ColorCombinationViewModel.self) private var viewModel
    
    let swatch: Swatch
    
    var body: some View {
        LazyVStack(pinnedViews: .sectionHeaders) {
            Section {
                if let colors = viewModel.colorsBySwatch[swatch.id] {
                    ForEach(colors) { color in
                        NavigationLink(value: color) {
                            ColorRow(color: color)
                                .copyFormats(of: color)
                        }
                    }
                }
            } header: {
                SectionHeader(swatch: swatch)
            }
        }
    }
}
