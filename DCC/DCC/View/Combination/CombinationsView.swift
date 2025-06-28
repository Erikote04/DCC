//
//  CombinationsView.swift
//  DCC
//
//  Created by Erik Sebastian de Erice Jerez on 26/6/25.
//

import SwiftUI

struct CombinationsView: View {
    @Environment(\.colorScheme) private var colorScheme
    @EnvironmentObject private var viewModel: ColorCombinationViewModel
    
    @State private var searchText = ""
    
    var backgroundColor: SwiftUI.Color {
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
        .navigationDestination(for: Combination.self) { combination in
            CombinationDetailView(combination: combination)
        }
        .toolbarBackground(backgroundColor)
        .searchable(text: $searchText, prompt: "Search combinations by ID or color names")
    }
}

fileprivate struct CombinationRow: View {
    let combination: Combination
    
    var body: some View {
        HStack {
            Text("#\(combination.id)")
                .font(.headline)
                .foregroundColor(.primary)
            
            Spacer()
            
            HStack(spacing: 0) {
                ForEach(Array(combination.colors.enumerated()), id: \.offset) { index, color in
                    Rectangle()
                        .fill(color.color)
                        .frame(maxWidth: .infinity)
                }
            }
            .frame(height: 40)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(.tertiary, lineWidth: 2)
            )
            .padding(.horizontal)
            
            Spacer()
        }
    }
}

#Preview("Light") {
    NavigationStack {
        CombinationsView()
            .environmentObject(ColorCombinationViewModel())
    }
}

#Preview("Dark") {
    NavigationStack {
        CombinationsView()
            .environmentObject(ColorCombinationViewModel())
            .preferredColorScheme(.dark)
    }
}
