//
//  CombinationRow.swift
//  DCC
//
//  Created by Erik Sebastian de Erice Jerez on 25/11/25.
//

import SwiftUI

struct CombinationRow: View {
    let combination: Combination
    
    var body: some View {
        HStack(spacing: .zero) {
            ForEach(Array(combination.colors.enumerated()), id: \.offset) { index, color in
                Rectangle()
                    .fill(color.color)
                    .frame(maxWidth: .infinity)
            }
        }
        .frame(height: 44)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(.tertiary, lineWidth: 2)
        )
    }
}
