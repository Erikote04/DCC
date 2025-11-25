//
//  ColorCombinationView.swift
//  DCC
//
//  Created by Erik Sebastian de Erice Jerez on 28/6/25.
//

import SwiftUI

struct TabBarView: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.openURL) private var openURL
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
        .alert("New version available", isPresented: $viewModel.versionChecker.showUpdateAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Update") {
                if let url = viewModel.versionChecker.appStoreURL {
                    openURL(url)
                }
            }
        } message: {
            Text("There is a new version available in the App Store.")
        }
        .task {
            await viewModel.versionChecker.checkForUpdate()
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
