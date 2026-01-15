//
//  ScannerCombinationDetailView.swift
//  DCC
//
//  Created by Erik Sebastian de Erice Jerez on 14/1/26.
//

import SwiftUI

struct ScannerCombinationDetailView: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.displayScale) var displayScale
    @Environment(FavoritesManager.self) private var favoritesManager
    
    let scannerCombination: [PhotoColorData]
    let favoriteItem: FavoriteItem
    
    @State private var shareImage = Image(systemName: "photo")
    
    private var backgroundColor: Color {
        colorScheme == .dark ? .black : .white
    }
    
    private var isFavorite: Bool {
        favoritesManager.isFavorite(favoriteItem)
    }
    
    var body: some View {
        VStack(spacing: .zero) {
            GeometryReader { geometry in
                VStack(spacing: .zero) {
                    ForEach(scannerCombination, id: \.hex) { colorData in
                        NavigationLink {
                            ScannerColorDetailView(
                                photoColorData: colorData,
                                favoriteItem: FavoriteItem(scannerColor: colorData)
                            )
                        } label: {
                            colorCombinationFrame(for: colorData, using: geometry)
                        }
                    }
                }
            }
        }
        .navigationTitle("Scanner Combination")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(backgroundColor)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                HStack(spacing: 16) {
                    Button {
                        toggleFavorite()
                    } label: {
                        Image(systemName: isFavorite ? "bookmark.fill" : "bookmark")
                            .foregroundStyle(isFavorite ? .yellow : .primary)
                    }
                    
                    ShareLink(
                        item: shareImage,
                        preview: SharePreview(
                            "Scanner Combination",
                            image: shareImage
                        )
                    ) {
                        Image(systemName: "square.and.arrow.up")
                    }
                }
            }
        }
        .onAppear { renderCombinationImage() }
    }
    
    @ViewBuilder
    private func colorCombinationFrame(for colorData: PhotoColorData, using geometry: GeometryProxy) -> some View {
        let color = Color(hex: colorData.hex) ?? .gray
        
        Rectangle()
            .fill(color)
            .frame(maxWidth: .infinity, maxHeight: geometry.size.height / CGFloat(scannerCombination.count))
            .contextMenu {
                Button {
                    UIPasteboard.general.string = colorData.hex
                } label: {
                    Label("Copy HEX", systemImage: "doc.on.doc")
                }
                
                Button {
                    UIPasteboard.general.string = colorData.rgb
                } label: {
                    Label("Copy RGB", systemImage: "doc.on.doc")
                }
                
                Button {
                    UIPasteboard.general.string = colorData.cmyk
                } label: {
                    Label("Copy CMYK", systemImage: "doc.on.doc")
                }
            }
    }
    
    @MainActor
    private func renderCombinationImage() {
        let combinationForImage = VStack(spacing: 0) {
            ForEach(scannerCombination, id: \.hex) { colorData in
                Rectangle()
                    .fill(Color(hex: colorData.hex) ?? .gray)
                    .frame(maxWidth: .infinity)
            }
        }
        .frame(width: 400, height: 700)
        .background(Color(UIColor.systemBackground))
        
        let renderer = ImageRenderer(content: combinationForImage)
        renderer.scale = displayScale
        
        if let uiImage = renderer.uiImage {
            shareImage = Image(uiImage: uiImage)
        }
    }
    
    private func toggleFavorite() {
        favoritesManager.toggleFavorite(favoriteItem)
    }
}
