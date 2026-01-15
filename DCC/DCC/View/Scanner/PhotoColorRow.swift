//
//  PhotoColorRow.swift
//  DCC
//
//  Created by Erik Sebastian de Erice Jerez on 13/11/25.
//

import SwiftUI

struct PhotoColorRow: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(FavoritesManager.self) private var favoritesManager
    
    let photoColor: PhotoColor
    
    private var isFavorite: Bool {
        favoritesManager.isFavoriteScannerColor(hex: photoColor.hex)
    }
    
    var body: some View {
        HStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 4) {
                Text(photoColor.hex)
                    .font(.headline)
                
                Text(photoColor.rgb)
                    .font(.subheadline)
                
                Text(photoColor.cmyk)
                    .font(.subheadline)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer()
            
            Button {
                toggleFavorite()
            } label: {
                Image(systemName: isFavorite ? "bookmark.fill" : "bookmark")
                    .foregroundStyle(isFavorite ? .yellow : photoColor.color.contrastingTextColor())
                    .font(.title3)
                    .padding(8)
                    .contentShape(Rectangle())
            }
        }
        .padding()
        .foregroundStyle(photoColor.color.contrastingTextColor())
        .background(photoColor.color)
        .cornerRadius(8)
        .copyFormats(of: photoColor)
    }
    
    private func toggleFavorite() {
        let colorData = PhotoColorData(from: photoColor)
        
        if let existingItem = favoritesManager.getFavoriteItemForScannerColor(hex: photoColor.hex) {
            favoritesManager.removeFavorite(existingItem)
        } else {
            let favoriteItem = FavoriteItem(scannerColor: colorData)
            favoritesManager.addFavorite(favoriteItem)
        }
    }
}
