//
//  CombinationsView.swift
//  DCC
//
//  Created by Erik Sebastian de Erice Jerez on 26/6/25.
//

import SwiftUI

struct CombinationsView: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(ColorCombinationViewModel.self) private var viewModel
    
    @State private var searchText = ""
    
    var backgroundColor: Color {
        colorScheme == .dark ? .black : .white
    }
    
    var filteredCombinations: [Combination] {
        if searchText.isEmpty {
            return viewModel.combinations
        }
        
        return viewModel.combinations.filter { combination in
            let colorMatch = combination.colors.contains { color in
                color.name.localizedCaseInsensitiveContains(searchText) ||
                color.hex.localizedCaseInsensitiveContains(searchText)
            }
            
            return colorMatch
        }
    }
    
    var body: some View {
        Group {
            if filteredCombinations.isEmpty && !searchText.isEmpty {
                ContentUnavailableView.search(text: searchText)
            } else {
                List {
                    ForEach(filteredCombinations) { combination in
                        NavigationLink(value: combination) {
                            CombinationRow(combination: combination)
                        }
                    }
                }
                .listStyle(.plain)
                .scrollIndicators(.hidden)
            }
        }
        .navigationTitle("Combinations")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(backgroundColor)
        .searchable(text: $searchText, prompt: "Search by color name or HEX code")
    }
}

#Preview("Light") {
    NavigationStack {
        CombinationsView()
            .environment(ColorCombinationViewModel())
    }
}

#Preview("Dark") {
    NavigationStack {
        CombinationsView()
            .environment(ColorCombinationViewModel())
            .preferredColorScheme(.dark)
    }
}
