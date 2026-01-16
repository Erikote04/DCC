//
//  FavoritesList.swift
//  DCC
//
//  Created by Erik Sebastian de Erice Jerez on 14/1/26.
//

import SwiftUI

struct FavoritesList: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(ColorCombinationViewModel.self) private var viewModel
    @Environment(FavoritesManager.self) private var favoritesManager
    
    let title: String
    let items: [FavoriteItem]
    
    private var backgroundColor: Color {
        colorScheme == .dark ? .black : .white
    }
    
    var body: some View {
        Group {
            if items.isEmpty {
                emptyStateView
            } else {
                listView
            }
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(backgroundColor)
    }
    
    // MARK: - Empty State
    
    @ViewBuilder
    private var emptyStateView: some View {
        ContentUnavailableView {
            Label("No Favorites Yet", systemImage: "bookmark.slash")
        } description: {
            Text("Items you favorite will appear here")
        }
    }
    
    // MARK: - List View
    
    @ViewBuilder
    private var listView: some View {
        List {
            ForEach(items) { item in
                switch (item.source, item.type) {
                case (.dictionary, .color):
                    if let colorId = item.colorId,
                       let color = getColorById(colorId) {
                        NavigationLink {
                            FavoriteColorDetailView(color: color)
                        } label: {
                            colorRowView(color: color, item: item)
                        }
                    }
                    
                case (.dictionary, .combination):
                    if let combinationId = item.combinationId,
                       let combination = viewModel.getCombination(by: combinationId) {
                        NavigationLink {
                            FavoriteCombinationDetailView(combination: combination)
                                .toolbarVisibility(.hidden, for: .tabBar)
                        } label: {
                            combinationRowView(combination: combination, item: item)
                        }
                    }
                    
                case (.scanner, .color):
                    if let scannerColor = item.scannerColor {
                        NavigationLink {
                            ScannerColorDetailView(
                                photoColorData: scannerColor,
                                favoriteItem: item
                            )
                        } label: {
                            scannerColorRowView(scannerColor: scannerColor, item: item)
                        }
                    }
                    
                case (.scanner, .combination):
                    if let scannerCombination = item.scannerCombination {
                        NavigationLink {
                            ScannerCombinationDetailView(
                                scannerCombination: scannerCombination,
                                favoriteItem: item
                            )
                            .toolbarVisibility(.hidden, for: .tabBar)
                        } label: {
                            scannerCombinationRowView(scannerCombination: scannerCombination, item: item)
                        }
                    }
                }
            }
            .onDelete(perform: deleteItems)
        }
        .listStyle(.plain)
    }
    
    // MARK: - Dictionary Color Row
    
    @ViewBuilder
    private func colorRowView(color: ColorModel, item: FavoriteItem) -> some View {
        HStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(color.color)
                .frame(width: 44, height: 44)
                .overlay {
                    if colorScheme == .dark && color.hex == "#000000" {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(.white.opacity(0.2), lineWidth: 2)
                    }
                }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(color.name)
                    .font(.headline)
                
                Text(color.hex)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button(role: .destructive) {
                favoritesManager.removeFavorite(item)
            } label: {
                Label("Delete", systemImage: "trash")
            }
            .tint(.red)
        }
    }
    
    // MARK: - Dictionary Combination Row
    
    @ViewBuilder
    private func combinationRowView(combination: Combination, item: FavoriteItem) -> some View {
        CombinationRow(combination: combination)
            .padding(.vertical, 4)
            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                Button(role: .destructive) {
                    favoritesManager.removeFavorite(item)
                } label: {
                    Label("Delete", systemImage: "trash")
                }
                .tint(.red)
            }
    }
    
    // MARK: - Scanner Color Row
    
    @ViewBuilder
    private func scannerColorRowView(scannerColor: PhotoColorData, item: FavoriteItem) -> some View {
        HStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(hex: scannerColor.hex) ?? .gray)
                .frame(width: 44, height: 44)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(scannerColor.hex)
                    .font(.headline)
                
                Text(scannerColor.rgb)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                Text(scannerColor.cmyk)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button(role: .destructive) {
                favoritesManager.removeFavorite(item)
            } label: {
                Label("Delete", systemImage: "trash")
            }
            .tint(.red)
        }
        .contextMenu {
            Button {
                UIPasteboard.general.string = scannerColor.hex
            } label: {
                Label("Copy HEX", systemImage: "doc.on.doc")
            }
            
            Button {
                UIPasteboard.general.string = scannerColor.rgb
            } label: {
                Label("Copy RGB", systemImage: "doc.on.doc")
            }
            
            Button {
                UIPasteboard.general.string = scannerColor.cmyk
            } label: {
                Label("Copy CMYK", systemImage: "doc.on.doc")
            }
        }
    }
    
    // MARK: - Scanner Combination Row
    
    @ViewBuilder
    private func scannerCombinationRowView(scannerCombination: [PhotoColorData], item: FavoriteItem) -> some View {
        HStack(spacing: .zero) {
            ForEach(scannerCombination, id: \.hex) { colorData in
                Rectangle()
                    .fill(Color(hex: colorData.hex) ?? .gray)
                    .frame(maxWidth: .infinity)
            }
        }
        .frame(height: 44)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(.tertiary, lineWidth: 2)
        )
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button(role: .destructive) {
                favoritesManager.removeFavorite(item)
            } label: {
                Label("Delete", systemImage: "trash")
            }
            .tint(.red)
        }
    }
    
    // MARK: - Helper Methods
    
    private func getColorById(_ id: Int) -> ColorModel? {
        viewModel.colorsBySwatch.values
            .flatMap { $0 }
            .first { $0.id == id }
    }
    
    private func deleteItems(at offsets: IndexSet) {
        for index in offsets {
            let item = items[index]
            favoritesManager.removeFavorite(item)
        }
    }
}

#Preview {
    NavigationStack {
        FavoritesList(
            title: "Dictionary Colors",
            items: []
        )
    }
    .environment(ColorCombinationViewModel())
    .environment(FavoritesManager())
}
