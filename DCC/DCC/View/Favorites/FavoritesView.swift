//
//  FavoritesView.swift
//  DCC
//
//  Created by Erik Sebastian de Erice Jerez on 14/1/26.
//

import SwiftUI

struct FavoritesView: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(FavoritesManager.self) private var favoritesManager
    
    private var backgroundColor: Color {
        colorScheme == .dark ? .black : .white
    }
    
    var body: some View {
        Form {
            dictionarySection
            scannerSection
        }
        .navigationTitle("Favorites")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(backgroundColor)
    }
    
    // MARK: - Sections
    
    @ViewBuilder
    private var dictionarySection: some View {
        Section("Dictionary of Color Combination (Vol. 1)") {
            NavigationLink {
                FavoritesList(
                    title: "Dictionary Colors",
                    items: favoritesManager.getDictionaryColors()
                )
            } label: {
                HStack {
                    Label("Colors", systemImage: "paintpalette.fill")
                    Spacer()
                    Text("\(favoritesManager.getDictionaryColors().count)")
                        .foregroundStyle(.secondary)
                }
            }
            
            NavigationLink {
                FavoritesList(
                    title: "Dictionary Combinations",
                    items: favoritesManager.getDictionaryCombinations()
                )
            } label: {
                HStack {
                    Label("Combinations", systemImage: "swatchpalette.fill")
                    Spacer()
                    Text("\(favoritesManager.getDictionaryCombinations().count)")
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
    
    @ViewBuilder
    private var scannerSection: some View {
        Section("Scanner") {
            NavigationLink {
                FavoritesList(
                    title: "Scanned Colors",
                    items: favoritesManager.getScannerColors()
                )
            } label: {
                HStack {
                    Label("Colors", systemImage: "paintpalette.fill")
                    Spacer()
                    Text("\(favoritesManager.getScannerColors().count)")
                        .foregroundStyle(.secondary)
                }
            }
            
            NavigationLink {
                FavoritesList(
                    title: "Scanned Combinations",
                    items: favoritesManager.getScannerCombinations()
                )
            } label: {
                HStack {
                    Label("Combinations", systemImage: "swatchpalette.fill")
                    Spacer()
                    Text("\(favoritesManager.getScannerCombinations().count)")
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        FavoritesView()
    }
    .environment(FavoritesManager())
}
