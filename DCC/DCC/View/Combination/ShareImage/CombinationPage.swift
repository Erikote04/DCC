//
//  CombinationPage.swift
//  DCC
//
//  Created by Erik Sebastian de Erice Jerez on 9/7/25.
//

import SwiftUI

struct CombinationPage: View {
    @Environment(\.colorScheme) private var colorScheme
    
    let combination: Combination
    
    var body: some View {
        VStack {
            colorsLayout(for: combination.colors)
        }
        .padding()
    }
    
    @ViewBuilder
    private func colorsLayout(for colors: [ColorModel]) -> some View {
        switch colors.count {
        case 4: fourColorsLayout(colors)
        default: threeColorsLayout(colors)
        }
    }
    
    @ViewBuilder
    private func twoColorsLayout(_ colors: [ColorModel]) -> some View {
        HStack {
            Rectangle()
                .frame(width: 2)
            
            VStack(alignment: .leading) {
                Text("\(combination.id)")
                    .font(.headline)
                    .foregroundStyle(.black)
                
                Spacer()
                
                HStack(spacing: .zero) {
                    ForEach(Array(combination.colors.enumerated()), id: \.offset) { index, color in
                        VStack {
                            Rectangle()
                                .fill(color.color)
                                .frame(maxWidth: .infinity)
                                .overlay {
                                    if color.name == "White" && colorScheme == .light {
                                        Rectangle()
                                            .stroke(.tertiary, lineWidth: 1)
                                    }
                                    
                                    if color.name == "Black" && colorScheme == .dark {
                                        Rectangle()
                                            .stroke(.tertiary, lineWidth: 1)
                                    }
                                }
                            
                            Text(color.name)
                        }
                    }
                }
                .frame(height: 150)
                
                Spacer()
            }
            .padding(.horizontal, 8)
        }
    }
    
    @ViewBuilder
    private func threeColorsLayout(_ colors: [ColorModel]) -> some View {
        twoColorsLayout(colors)
    }
    
    @ViewBuilder
    private func fourColorsLayout(_ colors: [ColorModel]) -> some View {
        let firstColor = colors[0]
        let secondColor = colors[1]
        let thirdColor = colors[2]
        let fourthColor = colors[3]
        
        HStack {
            Rectangle()
                .fill(.black)
                .frame(width: 2)
            
            VStack(alignment: .leading) {
                Text("\(combination.id)")
                    .font(.headline)
                
                Spacer()
                
                VStack(spacing: .zero) {
                    GeometryReader { proxy in
                        let width = proxy.size.width / 2
                        
                        HStack {
                            Spacer()
                            Rectangle()
                                .fill(firstColor.color)
                                .frame(width: width, height: 100)
                                .overlay {
                                    if firstColor.name == "Black" && colorScheme == .dark {
                                        Rectangle()
                                            .stroke(.tertiary, lineWidth: 1)
                                    }
                                }
                            Spacer()
                        }
                    }
                    
                    HStack(spacing: .zero) {
                        Rectangle()
                            .fill(secondColor.color)
                            .frame(height: 100)
                            .overlay {
                                if secondColor.name == "Black" && colorScheme == .dark {
                                    Rectangle()
                                        .stroke(.tertiary, lineWidth: 1)
                                }
                            }
                        
                        Rectangle()
                            .fill(thirdColor.color)
                            .frame(height: 100)
                            .overlay {
                                if thirdColor.name == "Black" && colorScheme == .dark {
                                    Rectangle()
                                        .stroke(.tertiary, lineWidth: 1)
                                }
                            }
                    }
                    .frame(maxWidth: .infinity)
                    
                    GeometryReader { proxy in
                        let width = proxy.size.width / 2
                        
                        HStack {
                            Spacer()
                            Rectangle()
                                .fill(fourthColor.color)
                                .frame(width: width, height: 100)
                                .overlay {
                                    if fourthColor.name == "Black" && colorScheme == .dark {
                                        Rectangle()
                                            .stroke(.tertiary, lineWidth: 1)
                                    }
                                }
                            Spacer()
                        }
                    }
                }
                .frame(height: 300)
                
                Spacer()
                
                textLayout(for: colors)
                
                Spacer()
            }
            .padding(.horizontal, 8)
        }
    }
    
    @ViewBuilder
    private func textLayout(for colors: [ColorModel]) -> some View {
        let firstColor = colors[0]
        let secondColor = colors[1]
        let thirdColor = colors[2]
        let fourthColor = colors[3]
        
        VStack {
            GeometryReader { proxy in
                let width = proxy.size.width / 2
                
                VStack {
                    Spacer()
                    Text(firstColor.name).multilineTextAlignment(.center)
                    Rectangle().frame(width: width, height: 1)
                }
                .frame(maxWidth: .infinity)
            }
            
            GeometryReader { proxy in
                let halfWidth = proxy.size.width / 2
                
                ZStack {
                    Rectangle()
                        .frame(width: 1)
                        .position(x: halfWidth, y: proxy.size.height / 2)
                    
                    HStack(spacing: 0) {
                        Text(secondColor.name)
                            .multilineTextAlignment(.center)
                            .frame(width: halfWidth)
                            .padding(.trailing, 8)
                        
                        Text(thirdColor.name)
                            .multilineTextAlignment(.center)
                            .frame(width: halfWidth)
                            .padding(.leading, 8)
                    }
                }
            }
            
            GeometryReader { proxy in
                let width = proxy.size.width / 2
                
                VStack {
                    Rectangle().frame(width: width, height: 1)
                    Text(fourthColor.name).multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
            }
        }
        .frame(height: 300)
    }
}

#Preview("2 Colors") {
    CombinationPage(combination: Combination(
        id: 1,
        colors: [
            ColorModel(
                id: 1,
                collectionId: 1,
                name: "Red",
                color: .red,
                hex: "",
                cmyk: "",
                rgb: "",
                combinations: [1]
            ),
            ColorModel(
                id: 2,
                collectionId: 2,
                name: "Green",
                color: .green,
                hex: "",
                cmyk: "",
                rgb: "",
                combinations: [2]
            ),
        ])
    )
}

#Preview("3 Colors") {
    CombinationPage(combination: Combination(
        id: 2,
        colors: [
            ColorModel(
                id: 1,
                collectionId: 1,
                name: "Red",
                color: .red,
                hex: "",
                cmyk: "",
                rgb: "",
                combinations: [1]
            ),
            ColorModel(
                id: 2,
                collectionId: 2,
                name: "Organge",
                color: .orange,
                hex: "",
                cmyk: "",
                rgb: "",
                combinations: [2]
            ),
            ColorModel(
                id: 3,
                collectionId: 3,
                name: "Yellow",
                color: .yellow,
                hex: "",
                cmyk: "",
                rgb: "",
                combinations: [3]
            ),
        ])
    )
}

#Preview("4 Colors") {
    CombinationPage(combination: Combination(
        id: 3,
        colors: [
            ColorModel(
                id: 1,
                collectionId: 1,
                name: "Indigo",
                color: .indigo,
                hex: "",
                cmyk: "",
                rgb: "",
                combinations: [1]
            ),
            ColorModel(
                id: 2,
                collectionId: 2,
                name: "Purple",
                color: .purple,
                hex: "",
                cmyk: "",
                rgb: "",
                combinations: [2]
            ),
            ColorModel(
                id: 3,
                collectionId: 3,
                name: "Lilac",
                color: .purple.opacity(0.5),
                hex: "",
                cmyk: "",
                rgb: "",
                combinations: [3]
            ),
            ColorModel(
                id: 4,
                collectionId: 4,
                name: "Pink",
                color: .pink,
                hex: "",
                cmyk: "",
                rgb: "",
                combinations: [4]
            ),
        ])
    )
}

