//
//  FavoriteItem.swift
//  DCC
//
//  Created by Erik Sebastian de Erice Jerez on 14/1/26.
//

import Foundation
import UIKit

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
    
    let colorId: Int?
    let combinationId: Int?
    let scannerColor: PhotoColorData?
    let scannerCombination: [PhotoColorData]?
    let thumbnailData: Data?
    
    init(colorId: Int, source: FavoriteSource = .dictionary) {
        self.id = "\(source.rawValue)-color-\(colorId)"
        self.source = source
        self.type = .color
        self.timestamp = Date()
        self.colorId = colorId
        self.combinationId = nil
        self.scannerColor = nil
        self.scannerCombination = nil
        self.thumbnailData = nil
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
        self.thumbnailData = nil
    }
    
    init(scannerColor: PhotoColorData) {
        self.id = "scanner-color-\(scannerColor.hex)"
        self.source = .scanner
        self.type = .color
        self.timestamp = Date()
        self.colorId = nil
        self.combinationId = nil
        self.scannerColor = scannerColor
        self.scannerCombination = nil
        self.thumbnailData = nil
    }
    
    init(scannerCombination: [PhotoColorData], thumbnail: UIImage? = nil) {
        let hexString = scannerCombination.map { $0.hex }.joined(separator: "-")
        self.id = "scanner-combination-\(hexString)"
        self.source = .scanner
        self.type = .combination
        self.timestamp = Date()
        self.colorId = nil
        self.combinationId = nil
        self.scannerColor = nil
        self.scannerCombination = scannerCombination
        
        if let thumbnail = thumbnail {
            self.thumbnailData = Self.generateThumbnail(from: thumbnail)
        } else {
            self.thumbnailData = nil
        }
    }
    
    private static func generateThumbnail(from image: UIImage, size: CGSize = CGSize(width: 64, height: 64)) -> Data? {
        let renderer = UIGraphicsImageRenderer(size: size)
        let thumbnail = renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: size))
        }
        
        return thumbnail.jpegData(compressionQuality: 0.5)
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
    
    init(hex: String, rgb: String, cmyk: String, percentage: Double) {
        self.hex = hex
        self.rgb = rgb
        self.cmyk = cmyk
        self.percentage = percentage
    }
}
