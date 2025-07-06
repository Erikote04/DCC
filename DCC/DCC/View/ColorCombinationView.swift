//
//  ColorCombinationView.swift
//  DCC
//
//  Created by Erik Sebastian de Erice Jerez on 28/6/25.
//

import SwiftUI

struct ColorCombinationView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject private var viewModel: ColorCombinationViewModel
    
    private var backgroundColor: SwiftUI.Color {
        colorScheme == .dark ? .black : .white
    }
    
    var body: some View {
        TabView(selection: $viewModel.selectedTab) {
            ForEach(TabItem.allCases) { tab in
                Tab(tab.title, systemImage: tab.image, value: tab) {
                    navigationView(for: tab)
                }
            }
        }
        .tint(.primary)
        .toolbarBackground(backgroundColor, for: .tabBar)
        .toolbarBackground(.visible, for: .tabBar)
    }
}

fileprivate extension ColorCombinationView {
    
    @ViewBuilder
    private func navigationView(for tab: TabItem) -> some View {
        NavigationStack {
            tab.body
                .navigationDestination(for: Combination.self) { combination in
                    CombinationDetailView(combination: combination)
                }
                .navigationDestination(for: Color.self) { color in
                    ColorDetailView(color: color)
                }
        }
    }
}

#Preview {
    ColorCombinationView()
        .environmentObject(ColorCombinationViewModel())
}
