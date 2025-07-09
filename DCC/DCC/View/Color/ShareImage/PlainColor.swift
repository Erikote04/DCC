//
//  PlainColor.swift
//  DCC
//
//  Created by Erik Sebastian de Erice Jerez on 9/7/25.
//

import SwiftUI

struct PlainColor: View {
    let color: Color
    
    var body: some View {
        ZStack {
            color.ignoresSafeArea()
        }
    }
}

#Preview {
    PlainColor(color: .red)
}
