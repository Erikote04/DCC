//
//  FavoriteItem.swift
//  DCC
//
//  Created by Erik Sebastian de Erice Jerez on 14/1/26.
//

import Foundation

enum FavoriteSource: String, Codable {
    case dictionary
    case scanner
}

enum FavoriteType: String, Codable {
    case color
    case combination
}

struct FavoriteItem: Codable, Identifiable, Hashable {
    let id: String
    let source: FavoriteSource
    let type: FavoriteType
    let timestamp: Date
    
    // Para colores del diccionario
    let colorId: Int?
    
    // Para combinaciones del diccionario
    let combinationId: Int?
    
    // Para colores del scanner
    let scannerColor: PhotoColorData?
    
    // Para combinaciones del scanner
    let scannerCombination: [PhotoColorData]?
    
    init(colorId: Int, source: FavoriteSource = .dictionary) {
        self.id = "\(source.rawValue)-color-\(colorId)"
        self.source = source
        self.type = .color
        self.timestamp = Date()
        self.colorId = colorId
        self.combinationId = nil
        self.scannerColor = nil
        self.scannerCombination = nil
    }
    
    init(combinationId: Int, source: FavoriteSource = .dictionary) {
        self.id = "\(source.rawValue)-combination-\(combinationId)"
        self.source = source
        self.type = .combination
        self.timestamp = Date()
        self.colorId = nil
        self.combinationId = combinationId
        self.scannerColor = nil
        self.scannerCombination = nil
    }
    
    init(scannerColor: PhotoColorData) {
        self.id = "scanner-color-\(UUID().uuidString)"
        self.source = .scanner
        self.type = .color
        self.timestamp = Date()
        self.colorId = nil
        self.combinationId = nil
        self.scannerColor = scannerColor
        self.scannerCombination = nil
    }
    
    init(scannerCombination: [PhotoColorData]) {
        self.id = "scanner-combination-\(UUID().uuidString)"
        self.source = .scanner
        self.type = .combination
        self.timestamp = Date()
        self.colorId = nil
        self.combinationId = nil
        self.scannerColor = nil
        self.scannerCombination = scannerCombination
    }
}

struct PhotoColorData: Codable, Hashable {
    let hex: String
    let rgb: String
    let cmyk: String
    let percentage: Double
    
    init(from photoColor: PhotoColor) {
        self.hex = photoColor.hex
        self.rgb = photoColor.rgb
        self.cmyk = photoColor.cmyk
        self.percentage = photoColor.percentage
    }
}
