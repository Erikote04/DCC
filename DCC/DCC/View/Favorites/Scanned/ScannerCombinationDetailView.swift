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
    
    @State private var plainImage = Image(systemName: "photo")
    @State private var imageWithLabels = Image(systemName: "photo")
    @State private var showingShareDialog = false
    
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
                    
                    Button {
                        showingShareDialog = true
                    } label: {
                        Image(systemName: "square.and.arrow.up")
                    }
                }
            }
        }
        .onAppear {
            renderPlainImage()
            renderImageWithLabels()
        }
        .confirmationDialog(
            Text("How do you want to share this combination?"),
            isPresented: $showingShareDialog,
            titleVisibility: .visible
        ) {
            ShareLink(
                item: plainImage,
                preview: SharePreview(
                    "Scanner Combination",
                    image: plainImage
                )
            ) {
                Text("Plain Colors")
            }
            
            ShareLink(
                item: imageWithLabels,
                preview: SharePreview(
                    "Scanner Combination with Labels",
                    image: imageWithLabels
                )
            ) {
                Text("Colors with HEX Codes")
            }
        }
    }
    
    @ViewBuilder
    private func colorCombinationFrame(for colorData: PhotoColorData, using geometry: GeometryProxy) -> some View {
        let color = Color(hex: colorData.hex) ?? .gray
        
        Rectangle()
            .fill(color)
            .frame(maxWidth: .infinity, maxHeight: geometry.size.height / CGFloat(scannerCombination.count))
            .overlay {
                Text(colorData.hex)
                    .font(.headline)
                    .foregroundStyle(color.contrastingTextColor())
            }
            .contextMenu {
                Button {
                    UIPasteboard.general.string = colorData.hex
                } label: {
                    Text("Copy HEX")
                }
                
                Button {
                    UIPasteboard.general.string = colorData.rgb
                } label: {
                    Text("Copy RGB")
                }
                
                Button {
                    UIPasteboard.general.string = colorData.cmyk
                } label: {
                    Text("Copy CMYK")
                }
            }
    }
    
    @MainActor
    private func renderPlainImage() {
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
            plainImage = Image(uiImage: uiImage)
        }
    }
    
    @MainActor
    private func renderImageWithLabels() {
        let combinationForImage = VStack(spacing: 0) {
            ForEach(scannerCombination, id: \.hex) { colorData in
                Rectangle()
                    .fill(Color(hex: colorData.hex) ?? .gray)
                    .frame(maxWidth: .infinity)
                    .overlay(
                        Text(colorData.hex)
                            .font(.headline)
                            .foregroundStyle((Color(hex: colorData.hex) ?? .gray).contrastingTextColor())
                    )
            }
        }
        .frame(width: 400, height: 700)
        .background(Color(UIColor.systemBackground))
        
        let renderer = ImageRenderer(content: combinationForImage)
        renderer.scale = displayScale
        
        if let uiImage = renderer.uiImage {
            imageWithLabels = Image(uiImage: uiImage)
        }
    }
    
    private func toggleFavorite() {
        favoritesManager.toggleFavorite(favoriteItem)
    }
}
