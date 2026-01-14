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
    @State private var isFavorite = false
    
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
                Image(systemName: isFavorite ? "heart.fill" : "heart")
                    .foregroundStyle(isFavorite ? .red : photoColor.color.contrastingTextColor())
                    .font(.title3)
                    .padding(12)
                    .contentShape(Rectangle())
            }
        }
        .padding()
        .foregroundStyle(photoColor.color.contrastingTextColor())
        .background(photoColor.color)
        .cornerRadius(8)
        .copyFormats(of: photoColor)
        .onAppear {
            checkIfFavorite()
        }
    }
    
    private func toggleFavorite() {
        let colorData = PhotoColorData(from: photoColor)
        let favoriteItem = FavoriteItem(scannerColor: colorData)
        favoritesManager.toggleFavorite(favoriteItem)
        isFavorite = favoritesManager.isFavorite(favoriteItem)
    }
    
    private func checkIfFavorite() {
        let colorData = PhotoColorData(from: photoColor)
        let favoriteItem = FavoriteItem(scannerColor: colorData)
        isFavorite = favoritesManager.isFavorite(favoriteItem)
    }
}
