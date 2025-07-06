//
//  ContentView.swift
//  DCC
//
//  Created by Erik Sebastian de Erice Jerez on 25/6/25.
//

import SwiftUI

struct ColorsView: View {
    @Environment(\.colorScheme) private var colorScheme
    @EnvironmentObject private var viewModel: ColorCombinationViewModel
    
    @State private var searchText = ""
    
    var backgroundColor: SwiftUI.Color {
        colorScheme == .dark ? .black : .white
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            if searchText.isEmpty {
                ForEach(viewModel.swatches) { swatch in
                    if viewModel.isShowingGrid {
                        ColorGrid(swatch: swatch)
                    } else {
                        ColorList(swatch: swatch)
                    }
                }
            } else {
                let filteredColors = viewModel.swatches
                    .compactMap { viewModel.colorsBySwatch[$0.id] }
                    .flatMap { $0 }
                    .filter {
                        $0.name.localizedCaseInsensitiveContains(searchText)
                    }
                
                if filteredColors.isEmpty {
                    ContentUnavailableView.search(text: searchText)
                } else {
                    LazyVStack(alignment: .leading, spacing: 12) {
                        ForEach(filteredColors) { color in
                            NavigationLink(value: color) {
                                SearchResultRow(color: color)
                                    .padding(.horizontal)
                            }
                        }
                        .padding(.top)
                    }
                }
            }
        }
        .navigationTitle("Colors")
        .navigationBarTitleDisplayMode(.inline)
        .searchable(text: $searchText, prompt: "Search colors")
        .toolbarBackground(backgroundColor)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    viewModel.isShowingGrid.toggle()
                } label: {
                    Image(systemName: viewModel.isShowingGrid ? "list.bullet" : "square.grid.2x2")
                }
                .frame(width: 44, height: 44)
            }
        }
    }
}

fileprivate struct SearchResultRow: View {
    let color: Color
    
    var body: some View {
        HStack(spacing: 8) {
            Circle()
                .fill(color.color)
                .stroke(.secondary, lineWidth: 1)
                .frame(width: 32, height: 32)
            
            VStack(alignment: .leading) {
                Text(color.name)
                    .font(.headline)
                    .foregroundStyle(.primary)
                Text(color.hex)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.secondary)
        }
    }
}

#Preview("Light") {
    NavigationStack {
        ColorsView()
            .environmentObject(ColorCombinationViewModel())
    }
}

#Preview("Dark") {
    NavigationStack {
        ColorsView()
            .preferredColorScheme(.dark)
            .environmentObject(ColorCombinationViewModel())
    }
}
