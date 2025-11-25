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
            let idMatch = String(combination.id).contains(searchText)
            
            let colorNameMatch = combination.colors.contains { color in
                color.name.localizedCaseInsensitiveContains(searchText)
            }
            
            return idMatch || colorNameMatch
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
        .searchable(text: $searchText, prompt: "Search combinations by ID or color names")
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
