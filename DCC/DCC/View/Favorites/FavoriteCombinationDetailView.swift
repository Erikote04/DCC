//
//  FavoriteCombinationDetailView.swift
//  DCC
//
//  Created by Erik Sebastian de Erice Jerez on 14/1/26.
//

import SwiftUI

struct FavoriteCombinationDetailView: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.displayScale) var displayScale
    @Environment(FavoritesManager.self) private var favoritesManager
    
    @State var combination: Combination
    
    @State private var shareImage = Image(systemName: "photo")
    
    private var backgroundColor: Color {
        colorScheme == .dark ? .black : .white
    }
    
    private var isFavorite: Bool {
        favoritesManager.isFavoriteCombination(id: combination.id)
    }
    
    var body: some View {
        VStack(spacing: .zero) {
            GeometryReader { geometry in
                VStack(spacing: .zero) {
                    ForEach(combination.colors) { color in
                        NavigationLink {
                            FavoriteColorDetailView(color: color)
                        } label: {
                            colorCombinationFrame(for: color, using: geometry)
                        }
                    }
                }
            }
        }
        .navigationTitle("#\(combination.id)")
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
                            "Color Combination #\(combination.id)",
                            image: shareImage
                        )
                    ) {
                        Image(systemName: "square.and.arrow.up")
                    }
                }
            }
        }
        .onAppear { renderCombinationImage() }
        .onChange(of: combination) { renderCombinationImage() }
    }
    
    @ViewBuilder
    private func colorCombinationFrame(for color: ColorModel, using geometry: GeometryProxy) -> some View {
        Rectangle()
            .fill(color.color)
            .frame(maxWidth: .infinity, maxHeight: geometry.size.height / CGFloat(combination.colors.count))
            .overlay {
                VStack(alignment: .leading, spacing: 8) {
                    Text(color.name)
                        .font(.largeTitle)
                        .multilineTextAlignment(.leading)
                    
                    Text(color.hex)
                        .font(.headline)
                        .multilineTextAlignment(.leading)
                    
                    Text(color.rgb)
                        .font(.subheadline)
                        .multilineTextAlignment(.leading)
                    
                    Text(color.cmyk)
                        .font(.subheadline)
                        .multilineTextAlignment(.leading)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundStyle(color.color.contrastingTextColor())
                .padding(.leading)
            }
            .copyFormats(of: color)
    }
    
    @MainActor
    private func renderCombinationImage() {
        let combinationPageForImage = CombinationPage(combination: combination)
            .frame(width: 400, height: 700)
            .background(Color(UIColor.systemBackground))
        
        let renderer = ImageRenderer(content: combinationPageForImage)
        
        renderer.scale = displayScale
        
        if let uiImage = renderer.uiImage {
            shareImage = Image(uiImage: uiImage)
        }
    }
    
    private func toggleFavorite() {
        let favoriteItem = FavoriteItem(combinationId: combination.id)
        favoritesManager.toggleFavorite(favoriteItem)
    }
}

#Preview {
    NavigationStack {
        FavoriteCombinationDetailView(combination: Combination(
            id: 1,
            colors: [
                ColorModel(id: 1, collectionId: 1, name: "Red", color: .red, hex: "#FF0000", cmyk: "CMYK(0, 100, 100, 0)", rgb: "RGB(255, 0, 0)", combinations: [1]),
                ColorModel(id: 2, collectionId: 1, name: "Blue", color: .blue, hex: "#0000FF", cmyk: "CMYK(100, 100, 0, 0)", rgb: "RGB(0, 0, 255)", combinations: [1])
            ]
        ))
    }
    .environment(FavoritesManager())
}
