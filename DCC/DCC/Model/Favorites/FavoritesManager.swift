//
//  FavoritesManager.swift
//  DCC
//
//  Created by Erik Sebastian de Erice Jerez on 14/1/26.
//

import Foundation

@Observable
class FavoritesManager {
    private let userDefaultsKey = "savedFavorites"
    private(set) var favorites: [FavoriteItem] = []
    
    init() {
        loadFavorites()
    }
    
    // MARK: - Load & Save
    
    private func loadFavorites() {
        guard let data = UserDefaults.standard.data(forKey: userDefaultsKey),
              let decoded = try? JSONDecoder().decode([FavoriteItem].self, from: data) else {
            favorites = []
            return
        }
        favorites = decoded.sorted { $0.timestamp > $1.timestamp }
    }
    
    private func saveFavorites() {
        if let encoded = try? JSONEncoder().encode(favorites) {
            UserDefaults.standard.set(encoded, forKey: userDefaultsKey)
        }
    }
    
    // MARK: - Public Methods
    
    func toggleFavorite(_ item: FavoriteItem) {
        if isFavorite(item) {
            removeFavorite(item)
        } else {
            addFavorite(item)
        }
    }
    
    func addFavorite(_ item: FavoriteItem) {
        guard !isFavorite(item) else { return }
        favorites.append(item)
        saveFavorites()
    }
    
    func removeFavorite(_ item: FavoriteItem) {
        favorites.removeAll { $0.id == item.id }
        saveFavorites()
    }
    
    func isFavorite(_ item: FavoriteItem) -> Bool {
        favorites.contains { $0.id == item.id }
    }
    
    func isFavoriteColor(id: Int, source: FavoriteSource = .dictionary) -> Bool {
        let itemId = "\(source.rawValue)-color-\(id)"
        return favorites.contains { $0.id == itemId }
    }
    
    func isFavoriteCombination(id: Int, source: FavoriteSource = .dictionary) -> Bool {
        let itemId = "\(source.rawValue)-combination-\(id)"
        return favorites.contains { $0.id == itemId }
    }
    
    // MARK: - Filter Methods
    
    func getFavorites(source: FavoriteSource, type: FavoriteType) -> [FavoriteItem] {
        favorites.filter { $0.source == source && $0.type == type }
    }
    
    func getDictionaryColors() -> [FavoriteItem] {
        getFavorites(source: .dictionary, type: .color)
    }
    
    func getDictionaryCombinations() -> [FavoriteItem] {
        getFavorites(source: .dictionary, type: .combination)
    }
    
    func getScannerColors() -> [FavoriteItem] {
        getFavorites(source: .scanner, type: .color)
    }
    
    func getScannerCombinations() -> [FavoriteItem] {
        getFavorites(source: .scanner, type: .combination)
    }
}
