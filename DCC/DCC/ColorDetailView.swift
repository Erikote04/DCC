//
//  ColorDetailView.swift
//  DCC
//
//  Created by Erik Sebastian de Erice Jerez on 26/6/25.
//

import SwiftUI

struct ColorDetailView: View {
    @Environment(\.colorScheme) private var colorScheme
    
    let color: Color
    
    var backgroundColor: SwiftUI.Color {
        colorScheme == .dark ? .black : .white
    }
    
    var body: some View {
        VStack {
            Rectangle()
                .fill(color.color)
                .frame(height: 250)
            
            ScrollView {
                LazyVStack(alignment: .leading, pinnedViews: .sectionHeaders) {
                    Section {
                        ForEach(color.combinations, id: \.self) { combinationId in
                            Text("#\(combinationId)").padding()
                            Divider()
                        }
                    } header: {
                        VStack(alignment: .leading) {
                            Text(color.name)
                                .font(.largeTitle)
                            Text(color.hex)
                                .font(.headline)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(backgroundColor)
                    }
                }
            }
        }
        .navigationTitle("Detail")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        ColorDetailView(color: Color(
            id: 159,
            name: "Black",
            color: .black,
            hex: "#000000",
            combinations: [46, 52, 62],
            swatchCollection: 1
        ))
    }
}
