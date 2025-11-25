//
//  ColorCombinationView.swift
//  DCC
//
//  Created by Erik Sebastian de Erice Jerez on 28/6/25.
//

import StoreKit
import SwiftUI

struct TabBarView: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.requestReview) private var requestReview
    @Bindable var viewModel: ColorCombinationViewModel
    
    private var backgroundColor: Color {
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
        .sheet(isPresented: $viewModel.isShowingInfo) {
            InfoView()
        }
        .task {
            try? await Task.sleep(for: .seconds(5))
            requestReview()
        }
    }
    
    @ViewBuilder
    private func navigationView(for tab: TabItem) -> some View {
        NavigationStack {
            tab.body
                .navigationDestination(for: Combination.self) { combination in
                    CombinationDetailView(combination: combination)
                }
                .navigationDestination(for: ColorModel.self) { color in
                    ColorDetailView(color: color)
                }
                .toolbar {
                    ToolbarItem(placement: .automatic) {
                        Button {
                            viewModel.isShowingInfo.toggle()
                        } label: {
                            Image(systemName: "info.circle")
                                .accessibilityLabel("Info")
                        }
                        .frame(width: 44, height: 44)
                    }
                }
        }
    }
}



#Preview {
    TabBarView(viewModel: ColorCombinationViewModel())
        .environment(ColorCombinationViewModel())
}
