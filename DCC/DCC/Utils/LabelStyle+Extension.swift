//
//  LabelStyle+Extension.swift
//  DCC
//
//  Created by Erik Sebastian de Erice Jerez on 7/7/25.
//

import SwiftUI

struct Info: LabelStyle {
    let color: Color
    
    func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: 8) {
            configuration.icon
            configuration.title
        }
        .font(.headline)
        .foregroundStyle(color)
    }
}

extension LabelStyle where Self == Info {
    static func info(color: Color) -> Self {
        Self(color: color)
    }
}
