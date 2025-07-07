//
//  InfoSection.swift
//  DCC
//
//  Created by Erik Sebastian de Erice Jerez on 7/7/25.
//

import SwiftUI

enum InfoSection: String, CaseIterable, Identifiable {
    case colors
    case combinations
    case about
    
    var id: String { rawValue }
    
    var title: String {
        switch self {
        case .colors: return "Colors Info"
        case .combinations: return "Combinations Tip"
        case .about: return "About"
        }
    }
    
    var image: String {
        switch self {
        case .colors: return "drop.halffull"
        case .combinations: return "wand.and.sparkles.inverse"
        case .about: return "book.closed"
        }
    }
    
    var description: String {
        switch self {
        case .colors: return "The colors you see in this application are based on RGB values. This means that their appearance may vary slightly depending on the format you use - CMYK, RGB or hexadecimal - and even depending on the screen on which you view them."
        case .combinations: return "Remember that color combinations are not rigid rules or instructions to be followed to the letter. They are a source of inspiration, an invitation to explore and give life to your own creations, whether in fashion, decoration, illustration or any form of visual expression."
        case .about: return "The Dictionary of Color Combinations is a collection of 348 color combinations made from 159 colors. The publication covers a wide span of shades and hues based on the author Wada Sanzō's original six-volume work, which Haishoku Sōkan published from 1933 to 1934."
        }
    }
    
    var color: Color {
        switch self {
        case .colors: return .blue
        case .combinations: return .mint
        case .about: return .pink
        }
    }
    
    static let learnMoreURL: URL = URL(string: "https://en.wikipedia.org/wiki/Sanzo_Wada")!
    static let buyTheBookURL: URL = URL(string: "https://www.amazon.com/dp/4861522471")!
}
