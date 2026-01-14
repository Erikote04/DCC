//
//  ScannerColorDetailView.swift
//  DCC
//
//  Created by Erik Sebastian de Erice Jerez on 14/1/26.
//

import SwiftUI

struct ScannerColorDetailView: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.displayScale) var displayScale
    @Environment(FavoritesManager.self) private var favoritesManager
    
    let photoColorData: PhotoColorData
    let favoriteItem: FavoriteItem
    
    @State private var shareImage = Image(systemName: "photo")
    
    private var backgroundColor: Color {
        colorScheme == .dark ? .black : .white
    }
    
    private var color: Color {
        Color(hex: photoColorData.hex) ?? .gray
    }
    
    private var isFavorite: Bool {
        favoritesManager.isFavorite(favoriteItem)
    }
    
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(color)
                .frame(height: 250)
                .padding()
                .shadow(color: .black.opacity(0.4), radius: 8, x: 0, y: 4)
                .overlay {
                    if colorScheme == .dark && photoColorData.hex == "#000000" {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(.white.opacity(0.2), lineWidth: 2)
                            .frame(height: 250)
                            .padding()
                    }
                }
            
            VStack(alignment: .leading, spacing: 16) {
                VStack(alignment: .leading) {
                    Text(photoColorData.hex)
                        .font(.largeTitle)
                        .multilineTextAlignment(.leading)
                    
                    Text(photoColorData.rgb)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.leading)
                    
                    Text(photoColorData.cmyk)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.leading)
                    
                    if photoColorData.percentage > 0 {
                        Text(String(format: "%.1f%%", photoColorData.percentage))
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.leading)
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(backgroundColor)
                .contextMenu {
                    Button {
                        UIPasteboard.general.string = photoColorData.hex
                    } label: {
                        Label("Copy HEX", systemImage: "doc.on.doc")
                    }
                    
                    Button {
                        UIPasteboard.general.string = photoColorData.rgb
                    } label: {
                        Label("Copy RGB", systemImage: "doc.on.doc")
                    }
                    
                    Button {
                        UIPasteboard.general.string = photoColorData.cmyk
                    } label: {
                        Label("Copy CMYK", systemImage: "doc.on.doc")
                    }
                }
                
                Spacer()
            }
        }
        .navigationTitle("Scanner Color")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(backgroundColor)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                HStack(spacing: 16) {
                    Button {
                        toggleFavorite()
                    } label: {
                        Image(systemName: isFavorite ? "heart.fill" : "heart")
                            .foregroundStyle(isFavorite ? .red : .primary)
                    }
                    
                    ShareLink(
                        item: shareImage,
                        preview: SharePreview(
                            "Scanner Color: \(photoColorData.hex)",
                            image: shareImage
                        )
                    ) {
                        Image(systemName: "square.and.arrow.up")
                    }
                }
            }
        }
        .onAppear { renderColorImage() }
    }
    
    @MainActor
    private func renderColorImage() {
        let plainColorForImage = Rectangle()
            .fill(color)
            .frame(width: 400, height: 700)
            .background(Color(UIColor.systemBackground))
        
        let renderer = ImageRenderer(content: plainColorForImage)
        renderer.scale = displayScale
        
        if let uiImage = renderer.uiImage {
            shareImage = Image(uiImage: uiImage)
        }
    }
    
    private func toggleFavorite() {
        favoritesManager.toggleFavorite(favoriteItem)
    }
}
