//
//  ContentView.swift
//  DCC
//
//  Created by Erik Sebastian de Erice Jerez on 25/6/25.
//

import SwiftUI

struct SwatchesView: View {
    @Environment(\.colorScheme) private var colorScheme
    @EnvironmentObject private var viewModel: ColorViewModel
    
    @State private var searchText = ""
    
    var backgroundColor: SwiftUI.Color {
        colorScheme == .dark ? .black : .white
    }
    
    var body: some View {
        NavigationStack {
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
            .navigationTitle("Dictionary of Color Combinations")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: Color.self) { color in
                ColorDetailView(color: color)
            }
            .searchable(text: $searchText, prompt: "Search colors")
            .toolbarBackground(backgroundColor)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        viewModel.isShowingGrid.toggle()
                    } label: {
                        Image(systemName: viewModel.isShowingGrid ? "square.grid.2x2" : "list.bullet")
                    }
                    .frame(width: 44, height: 44)
                }
            }
        }
        .tint(.primary)
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

fileprivate struct ColorGrid: View {
    @Environment(\.colorScheme) private var colorScheme
    @EnvironmentObject private var viewModel: ColorViewModel
    
    let swatch: Swatch
    
    private let spacing: CGFloat = 0
    private let minCellWidth: CGFloat = 150
    
    var backgroundColor: SwiftUI.Color {
        colorScheme == .dark ? .black : .white
    }
    
    var columns: [GridItem] {
        [GridItem(.adaptive(minimum: minCellWidth), spacing: .zero)]
    }
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: .zero, pinnedViews: .sectionHeaders) {
            Section {
                if let colors = viewModel.colorsBySwatch[swatch.id] {
                    ForEach(colors) { color in
                        NavigationLink(value: color) {
                            GeometryReader { geometry in
                                ColorCell(
                                    color: color,
                                    size: geometry.size.width
                                )
                            }
                            .aspectRatio(1, contentMode: .fit)
                        }
                    }
                    .padding()
                }
            } header: {
                Text("Swatch Collection \(swatch.id)")
                    .font(.title2)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(backgroundColor)
            }
        }
    }
}

fileprivate struct ColorCell: View {
    let color: Color
    let size: CGFloat
    
    var body: some View {
        ZStack(alignment: .bottom) {
            color.color
            
            VStack(alignment: .leading) {
                Text(color.name)
                    .font(.headline)
                    .foregroundStyle(.black)
                    .multilineTextAlignment(.leading)
                
                Text(color.hex)
                    .font(.subheadline)
                    .foregroundStyle(.gray)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(8)
            .background(.white)
        }
        .frame(width: size, height: size)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.2), radius: 6, x: 2, y: 4)
    }
}

fileprivate struct ColorList: View {
    @Environment(\.colorScheme) private var colorScheme
    @EnvironmentObject private var viewModel: ColorViewModel
    
    let swatch: Swatch
    
    var backgroundColor: SwiftUI.Color {
        colorScheme == .dark ? .black : .white
    }
    
    var body: some View {
        LazyVStack(pinnedViews: .sectionHeaders) {
            Section {
                if let colors = viewModel.colorsBySwatch[swatch.id] {
                    ForEach(colors) { color in
                        NavigationLink(value: color) {
                            ColorRow(color: color)
                        }
                    }
                }
            } header: {
                Text("Swatch Collection \(swatch.id)")
                    .font(.title2)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(backgroundColor)
            }
        }
    }
}

fileprivate struct ColorRow: View {
    @Environment(\.colorScheme) private var colorScheme
    
    let color: Color
    
    var backgroundColor: SwiftUI.Color {
        colorScheme == .dark ? .black : .white
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            SwiftUI.Color(color.color)
            
            HStack {
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
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .accessibilityHidden(true)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(backgroundColor)
        }
        .frame(height: 200)
    }
}

#Preview("Light") {
    SwatchesView()
        .environmentObject(ColorViewModel())
}

#Preview("Dark") {
    SwatchesView()
        .preferredColorScheme(.dark)
        .environmentObject(ColorViewModel())
}
