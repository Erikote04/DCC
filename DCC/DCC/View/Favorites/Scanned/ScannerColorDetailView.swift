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
    
    @State private var plainImage = Image(systemName: "photo")
    @State private var showingShareDialog = false
    
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
        .onAppear { renderPlainImage() }
        .confirmationDialog(
            Text("How do you want to share this color?"),
            isPresented: $showingShareDialog,
            titleVisibility: .visible
        ) {
            ShareLink(
                item: plainImage,
                preview: SharePreview(
                    "Scanner Color: \(photoColorData.hex)",
                    image: plainImage
                )
            ) {
                Text("Plain Color")
            }
            
            ShareLink(
                item: renderColorDataImage(),
                preview: SharePreview(
                    "Scanner Color Data: \(photoColorData.hex)",
                    image: renderColorDataImage()
                )
            ) {
                Text("Color Data")
            }
        }
    }
    
    @MainActor
    private func renderPlainImage() {
        let plainColorForImage = Rectangle()
            .fill(color)
            .frame(width: 400, height: 700)
            .background(Color(UIColor.systemBackground))
        
        let renderer = ImageRenderer(content: plainColorForImage)
        renderer.scale = displayScale
        
        if let uiImage = renderer.uiImage {
            plainImage = Image(uiImage: uiImage)
        }
    }
    
    @MainActor
    private func renderColorDataImage() -> Image {
        let colorDataForImage = ScannedColorData(photoColorData: photoColorData)
            .frame(width: 400, height: 700)
            .background(Color(UIColor.systemBackground))
        
        let renderer = ImageRenderer(content: colorDataForImage)
        renderer.scale = displayScale
        
        if let uiImage = renderer.uiImage {
            return Image(uiImage: uiImage)
        }
        
        return Image(systemName: "photo")
    }
    
    private func toggleFavorite() {
        favoritesManager.toggleFavorite(favoriteItem)
    }
}

#Preview {
    NavigationStack {
        ScannerColorDetailView(
            photoColorData: PhotoColorData(
                hex: "#FF5733",
                rgb: "RGB(255, 87, 51)",
                cmyk: "CMYK(0, 66, 80, 0)",
                percentage: 45.5
            ),
            favoriteItem: FavoriteItem(
                scannerColor: PhotoColorData(
                    hex: "#FF5733",
                    rgb: "RGB(255, 87, 51)",
                    cmyk: "CMYK(0, 66, 80, 0)",
                    percentage: 45.5
                )
            )
        )
    }
    .environment(FavoritesManager())
}
