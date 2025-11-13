//
//  ColorExtractor.swift
//  DCC
//
//  Created by Erik Sebastian de Erice Jerez on 13/11/25.
//

import SwiftUI
import UIKit

class ColorExtractor {
    
    static func extractDominantColors(from image: UIImage, count: Int = 8) -> [PhotoColor] {
        guard image.cgImage != nil else { return [] }
        
        let size = CGSize(width: 100, height: 100)
        UIGraphicsBeginImageContext(size)
        image.draw(in: CGRect(origin: .zero, size: size))
        guard let resizedImage = UIGraphicsGetImageFromCurrentImageContext(),
              let resizedCGImage = resizedImage.cgImage else {
            UIGraphicsEndImageContext()
            return []
        }
        UIGraphicsEndImageContext()
        
        let width = resizedCGImage.width
        let height = resizedCGImage.height
        let bytesPerPixel = 4
        let bytesPerRow = bytesPerPixel * width
        let bitsPerComponent = 8
        
        var pixelData = [UInt8](repeating: 0, count: width * height * bytesPerPixel)
        
        guard let context = CGContext(
            data: &pixelData,
            width: width,
            height: height,
            bitsPerComponent: bitsPerComponent,
            bytesPerRow: bytesPerRow,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        ) else { return [] }
        
        context.draw(resizedCGImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        
        var colorMap: [String: (color: Color, count: Int)] = [:]
        
        for y in 0..<height {
            for x in 0..<width {
                let offset = (y * width + x) * bytesPerPixel
                let r = CGFloat(pixelData[offset]) / 255.0
                let g = CGFloat(pixelData[offset + 1]) / 255.0
                let b = CGFloat(pixelData[offset + 2]) / 255.0
                let a = CGFloat(pixelData[offset + 3]) / 255.0
                
                if a < 0.5 { continue }
                let brightness = (r + g + b) / 3
                if brightness < 0.1 || brightness > 0.95 { continue }
                
                let quantized = quantizeColor(r: r, g: g, b: b, levels: 8)
                let key = "\(quantized.r)-\(quantized.g)-\(quantized.b)"
                
                let color = Color(red: quantized.r, green: quantized.g, blue: quantized.b)
                
                if let existing = colorMap[key] {
                    colorMap[key] = (color, existing.count + 1)
                } else {
                    colorMap[key] = (color, 1)
                }
            }
        }
        
        let totalPixels = colorMap.values.reduce(0) { $0 + $1.count }
        let sortedColors = colorMap.values
            .sorted { $0.count > $1.count }
            .prefix(count)
            .map { PhotoColor(color: $0.color, percentage: Double($0.count) / Double(totalPixels) * 100) }
        
        return sortedColors
    }
    
    static func extractColor(from image: UIImage, at point: CGPoint) -> PhotoColor? {
        guard let cgImage = image.cgImage else { return nil }
        
        let width = cgImage.width
        let height = cgImage.height
        let x = Int(point.x * CGFloat(width))
        let y = Int(point.y * CGFloat(height))
        
        guard x >= 0, x < width, y >= 0, y < height else { return nil }
        
        let bytesPerPixel = 4
        let bitsPerComponent = 8
        
        var pixelData = [UInt8](repeating: 0, count: bytesPerPixel)
        
        guard let context = CGContext(
            data: &pixelData,
            width: 1,
            height: 1,
            bitsPerComponent: bitsPerComponent,
            bytesPerRow: bytesPerPixel,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        ) else { return nil }
        
        context.draw(cgImage, in: CGRect(x: -x, y: -y, width: width, height: height))
        
        let r = CGFloat(pixelData[0]) / 255.0
        let g = CGFloat(pixelData[1]) / 255.0
        let b = CGFloat(pixelData[2]) / 255.0
        
        let color = Color(red: r, green: g, blue: b)
        return PhotoColor(color: color)
    }
    
    private static func quantizeColor(r: CGFloat, g: CGFloat, b: CGFloat, levels: Int) -> (r: CGFloat, g: CGFloat, b: CGFloat) {
        let step = 1.0 / CGFloat(levels)
        return (
            r: round(r / step) * step,
            g: round(g / step) * step,
            b: round(b / step) * step
        )
    }
}
