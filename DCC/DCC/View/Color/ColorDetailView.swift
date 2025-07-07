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
    
    let color: ColorModel
    
    private var backgroundColor: Color {
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
                                .multilineTextAlignment(.leading)
                            
                            Text(color.hex)
                                .font(.headline)
                                .multilineTextAlignment(.leading)
                            
                            Text(color.rgb)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.leading)
                            
                            Text(color.cmyk)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.leading)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(backgroundColor)
                        .copyFormats(of: color)
                    }
                }
            }
        }
        .navigationTitle(color.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(backgroundColor)
    }
}

#Preview {
    NavigationStack {
        ColorDetailView(color: ColorModel(
            id: 159,
            collectionId: 6,
            name: "Black",
            color: .black,
            hex: "#000000",
            cmyk: "CMYK: 20 10 15 100",
            rgb: "RGB: 0 0 0",
            combinations: [46, 52, 62]
        ))
    }
    .environmentObject(ColorCombinationViewModel())
    .tint(.primary)
}
