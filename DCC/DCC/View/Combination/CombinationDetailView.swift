//
//  CombinationDetailView.swift
//  DCC
//
//  Created by Erik Sebastian de Erice Jerez on 28/6/25.
//

import SwiftUI

struct CombinationDetailView: View {
    @State var combination: Combination
    @Environment(\.colorScheme) private var colorScheme
    @EnvironmentObject private var viewModel: ColorCombinationViewModel
    
    private var currentIndex: Int {
        viewModel.combinations.firstIndex(where: { $0.id == combination.id }) ?? 0
    }
    
    private var hasPreviousCombination: Bool {
        currentIndex > 0
    }
    
    private var hasNextCombination: Bool {
        currentIndex < viewModel.combinations.count - 1
    }
    
    private var previousCombination: Combination? {
        hasPreviousCombination ? viewModel.combinations[currentIndex - 1] : nil
    }
    
    private var nextCombination: Combination? {
        hasNextCombination ? viewModel.combinations[currentIndex + 1] : nil
    }
    
    private var backGroundColor: SwiftUI.Color {
        colorScheme == .dark ? .black : .white
    }
    
    var body: some View {
        VStack(spacing: .zero) {
            GeometryReader { geometry in
                VStack(spacing: .zero) {
                    ForEach(combination.colors) { color in
                        NavigationLink(value: color) {
                            colorCombinationFrame(for: color, using: geometry)
                        }
                    }
                }
            }
        }
        .navigationTitle("#\(combination.id)")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(backGroundColor)
        .toolbar {
            ToolbarItemGroup(placement: .navigation) {
                HStack {
                    Button { navigateToPreviousCombination() }
                    label: { Image(systemName: "chevron.left") }
                        .frame(width: 44, height: 44)
                        .disabled(!hasPreviousCombination)
                    
                    Button { navigateToNextCombination() }
                    label: { Image(systemName: "chevron.right") }
                        .frame(width: 44, height: 44)
                        .disabled(!hasNextCombination)
                }
            }
        }
    }
    
    @ViewBuilder
    private func colorCombinationFrame(for color: Color, using geometry: GeometryProxy) -> some View {
        Rectangle()
            .fill(color.color)
            .frame(maxWidth: .infinity, maxHeight: geometry.size.height / CGFloat(combination.colors.count))
            .overlay {
                VStack(alignment: .leading, spacing: 8) {
                    Text(color.name)
                        .font(.headline)
                    
                    Text(color.hex)
                        .font(.subheadline)
                    
                    Text(color.rgb)
                        .font(.caption)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundStyle(color.color.contrastingTextColor())
                .padding(.leading)
            }
    }
    
    private func navigateToPreviousCombination() {
        guard let prevCombination = previousCombination else { return }
        combination = prevCombination
    }
    
    private func navigateToNextCombination() {
        guard let nextComb = nextCombination else { return }
        combination = nextComb
    }
}
