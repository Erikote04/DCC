//
//  ColorCombinationView.swift
//  DCC
//
//  Created by Erik Sebastian de Erice Jerez on 28/6/25.
//

import StoreKit
import SwiftUI

struct ColorCombinationView: View {
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
        .onAppear {
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

fileprivate struct InfoView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.openURL) private var openURL
    @Environment(ColorCombinationViewModel.self) private var viewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 16) {
                        ForEach(InfoSection.allCases) { section in
                            cellForSection(section)
                        }
                    }
                    .padding()
                }
                
                Text(viewModel.appVersion)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .padding(.vertical)
            }
            .navigationTitle("Info")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle")
                            .accessibilityLabel("Close")
                    }
                    .frame(width: 44, height: 44)
                }
            }
            .tint(.primary)
        }
    }
    
    @ViewBuilder
    private func cellForSection(_ section: InfoSection) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Label(section.title, systemImage: section.image)
                .labelStyle(.info(color: section.color))
            
            Text(section.description)
                .font(.subheadline)
            
            if section == .about {
                Button {
                    openURL(InfoSection.learnMoreURL)
                } label: {
                    Text("Learn more")
                        .font(.subheadline.bold())
                        .underline()
                }
                .buttonStyle(.plain)
            }
        }
        .padding()
        .background(section.color.opacity(0.2), in: .rect(cornerRadius: 8))
    }
}

#Preview {
    ColorCombinationView(viewModel: ColorCombinationViewModel())
        .environment(ColorCombinationViewModel())
}
