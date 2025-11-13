//
//  PhotoColor.swift
//  DCC
//
//  Created by Erik Sebastian de Erice Jerez on 13/11/25.
//

import SwiftUI

struct PhotoColor: Identifiable, Hashable {
    let id = UUID()
    let color: Color
    let hex: String
    let cmyk: String
    let rgb: String
    let percentage: Double
    
    init(color: Color, percentage: Double = 0) {
        self.color = color
        self.percentage = percentage
        
        let uiColor = UIColor(color)
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        let r = Int(red * 255)
        let g = Int(green * 255)
        let b = Int(blue * 255)
        
        self.hex = String(format: "#%02X%02X%02X", r, g, b)
        self.rgb = "RGB(\(r), \(g), \(b))"
        
        let k = 1 - max(red, green, blue)
        let c = k == 1 ? 0 : (1 - red - k) / (1 - k)
        let m = k == 1 ? 0 : (1 - green - k) / (1 - k)
        let y = k == 1 ? 0 : (1 - blue - k) / (1 - k)
        
        let cVal = Int(c * 100)
        let mVal = Int(m * 100)
        let yVal = Int(y * 100)
        let kVal = Int(k * 100)
        
        self.cmyk = "CMYK(\(cVal), \(mVal), \(yVal), \(kVal))"
    }
}
