//
//  ColorDetailView.swift
//  DCC
//
//  Created by Erik Sebastian de Erice Jerez on 26/6/25.
//

import SwiftUI

struct ColorDetailView: View {
    @Environment(\.colorScheme) private var colorScheme
    @EnvironmentObject private var viewModel: ColorCombinationViewModel
    
    let color: Color
    
    private var backgroundColor: SwiftUI.Color {
        colorScheme == .dark ? .black : .white
    }
    
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(color.color)
                .frame(height: 250)
                .padding()
                .shadow(color: .black.opacity(0.4), radius: 8, x: 0, y: 4)
                .overlay {
                    if colorScheme == .dark && color.hex == "#000000" {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(.white.opacity(0.2), lineWidth: 2)
                            .frame(height: 250)
                            .padding()
                    }
                }
            
            ScrollView(showsIndicators: false) {
                LazyVStack(alignment: .leading, pinnedViews: .sectionHeaders) {
                    Section {
                        ForEach(color.combinations, id: \.self) { combinationId in
                            let combination = viewModel.getCombination(by: combinationId)
                            
                            NavigationLink(value: combination) {
                                VStack {
                                    HStack {
                                        VStack(alignment: .leading) {
                                            Text("#\(combinationId)").padding()
                                        }
                                        
                                        Spacer()
                                        
                                        Image(systemName: "chevron.right")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 16, height: 16)
                                            .foregroundStyle(.secondary)
                                            .padding()
                                    }
                                    
                                    Divider()
                                }
                            }
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
        .navigationTitle(color.name)
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(for: Combination.self) { combination in
            CombinationDetailView(combination: combination)
        }
        .toolbarBackground(backgroundColor)
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
    .environmentObject(ColorCombinationViewModel())
    .tint(.primary)
}
