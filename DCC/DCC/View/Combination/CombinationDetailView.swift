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
        ScrollView(showsIndicators: false) {
            ForEach(combination.colors) { color in
                NavigationLink(value: color) {
                    ColorRow(color: color)
                }
            }
        }
        .padding(.top, 24)
        .navigationTitle("#\(combination.id)")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(for: Color.self) { color in
            ColorDetailView(color: color)
        }
        .toolbarBackground(backGroundColor)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
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
    
    private func navigateToPreviousCombination() {
        guard let prevCombination = previousCombination else { return }
        combination = prevCombination
    }
    
    private func navigateToNextCombination() {
        guard let nextComb = nextCombination else { return }
        combination = nextComb
    }
}
