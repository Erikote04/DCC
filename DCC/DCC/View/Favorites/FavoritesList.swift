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
            Label("No Favorites Yet", systemImage: "heart.slash")
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
                        NavigationLink(value: color) {
                            colorRowView(color: color, item: item)
                        }
                    }
                    
                case (.dictionary, .combination):
                    if let combinationId = item.combinationId,
                       let combination = viewModel.getCombination(by: combinationId) {
                        NavigationLink(value: combination) {
                            combinationRowView(combination: combination, item: item)
                        }
                    }
                    
                case (.scanner, .color):
                    if let scannerColor = item.scannerColor {
                        scannerColorRowView(scannerColor: scannerColor, item: item)
                    }
                    
                case (.scanner, .combination):
                    if let scannerCombination = item.scannerCombination {
                        scannerCombinationRowView(scannerCombination: scannerCombination, item: item)
                    }
                }
            }
            .onDelete(perform: deleteItems)
        }
    }
    
    // MARK: - Dictionary Color Row
    
    @ViewBuilder
    private func colorRowView(color: ColorModel, item: FavoriteItem) -> some View {
        HStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(color.color)
                .frame(width: 60, height: 60)
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
        }
    }
    
    // MARK: - Dictionary Combination Row
    
    @ViewBuilder
    private func combinationRowView(combination: Combination, item: FavoriteItem) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Combination #\(combination.id)")
                .font(.headline)
            
            HStack(spacing: 0) {
                ForEach(combination.colors) { color in
                    Rectangle()
                        .fill(color.color)
                        .frame(maxWidth: .infinity)
                }
            }
            .frame(height: 40)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(.tertiary, lineWidth: 2)
            )
        }
        .padding(.vertical, 4)
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button(role: .destructive) {
                favoritesManager.removeFavorite(item)
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
    }
    
    // MARK: - Scanner Color Row
    
    @ViewBuilder
    private func scannerColorRowView(scannerColor: PhotoColorData, item: FavoriteItem) -> some View {
        HStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(hex: scannerColor.hex) ?? .gray)
                .frame(width: 60, height: 60)
            
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
        VStack(alignment: .leading, spacing: 8) {
            Text("Scanner Combination")
                .font(.headline)
            
            HStack(spacing: 0) {
                ForEach(scannerCombination, id: \.hex) { colorData in
                    Rectangle()
                        .fill(Color(hex: colorData.hex) ?? .gray)
                        .frame(maxWidth: .infinity)
                }
            }
            .frame(height: 40)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(.tertiary, lineWidth: 2)
            )
            
            VStack(alignment: .leading, spacing: 4) {
                ForEach(scannerCombination, id: \.hex) { colorData in
                    HStack {
                        Circle()
                            .fill(Color(hex: colorData.hex) ?? .gray)
                            .frame(width: 12, height: 12)
                        
                        Text(colorData.hex)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
        .padding(.vertical, 4)
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button(role: .destructive) {
                favoritesManager.removeFavorite(item)
            } label: {
                Label("Delete", systemImage: "trash")
            }
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

// MARK: - Color Extension for Hex

extension Color {
    init?(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            return nil
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
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
