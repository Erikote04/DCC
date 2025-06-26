//
//  CombinationsView.swift
//  DCC
//
//  Created by Erik Sebastian de Erice Jerez on 26/6/25.
//

import SwiftUI

struct CombinationsView: View {
    @Environment(\.colorScheme) private var colorScheme
    @EnvironmentObject private var viewModel: ColorViewModel
    
    var backgroundColor: SwiftUI.Color {
        colorScheme == .dark ? .black : .white
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.combinations) { combination in
                    CombinationRow(combination: combination)
                }
            }
            .listStyle(.plain)
            .scrollIndicators(.hidden)
            .navigationTitle("Combinations")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(backgroundColor)
        }
        .tint(.primary)
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
                    .stroke(.primary, lineWidth: 2)
            )
            .padding(.horizontal)
            
            Spacer()
        }
    }
}

#Preview("Light") {
    CombinationsView()
        .environmentObject(ColorViewModel())
}

#Preview("Dark") {
    CombinationsView()
        .environmentObject(ColorViewModel())
        .preferredColorScheme(.dark)
}
