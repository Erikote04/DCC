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
    
    var backgroundColor: SwiftUI.Color {
        colorScheme == .dark ? .black : .white
    }
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                ForEach(viewModel.swatches) { swatch in
                    if viewModel.isShowingGrid {
                        ColorGrid(swatch: swatch)
                    } else {
                        ColorList(swatch: swatch)
                    }
                }
            }
            .navigationTitle("Wada Sanzo Colors")
            .toolbarBackground(backgroundColor)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        viewModel.isShowingGrid.toggle()
                    } label: {
                        Image(systemName: viewModel.isShowingGrid ? "square.grid.2x2" : "list.bullet")
                            .tint(.primary)
                    }
                    .frame(width: 44, height: 44)
                }
            }
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
                        GeometryReader { geometry in
                            ColorCell(
                                color: color,
                                size: geometry.size.width
                            )
                        }
                        .aspectRatio(1, contentMode: .fit)
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
                        ColorRow(color: color)
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
            
            VStack(alignment: .leading) {
                Text(color.name)
                    .font(.headline)
                    .foregroundStyle(.primary)
                
                Text(color.hex)
                    .font(.subheadline)
                    .foregroundStyle(.primary)
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
