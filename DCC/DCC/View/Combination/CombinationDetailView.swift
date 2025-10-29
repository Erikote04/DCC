//
//  CombinationDetailView.swift
//  DCC
//
//  Created by Erik Sebastian de Erice Jerez on 28/6/25.
//

import Photos
import SwiftUI

struct CombinationDetailView: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.displayScale) var displayScale
    @Environment(ColorCombinationViewModel.self) private var viewModel
    
    @State private var shareImage = Image(systemName: "photo")
    
    @State var combination: Combination
    
    private var currentIndex: Int {
        viewModel.combinations.firstIndex(where: { $0.id == combination.id }) ?? 0
    }
    
    private var hasPreviousCombination: Bool {
        currentIndex > 0
    }
    
    private var hasNextCombination: Bool {
        currentIndex < viewModel.combinations.count - 1
    }
    
    private var previousCombination: Combination? {
        hasPreviousCombination ? viewModel.combinations[currentIndex - 1] : nil
    }
    
    private var nextCombination: Combination? {
        hasNextCombination ? viewModel.combinations[currentIndex + 1] : nil
    }
    
    private var backGroundColor: Color {
        colorScheme == .dark ? .black : .white
    }
    
    var body: some View {
        VStack(spacing: .zero) {
            GeometryReader { geometry in
                VStack(spacing: .zero) {
                    ForEach(combination.colors) { color in
                        NavigationLink(value: color) {
                            colorCombinationFrame(for: color, using: geometry)
                        }
                    }
                }
            }
        }
        .navigationTitle("#\(combination.id)")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(backGroundColor)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                ShareLink(
                    item: shareImage,
                    preview: SharePreview(
                        "Color Combination #\(combination.id)",
                        image: shareImage
                    )
                ) {
                    Image(systemName: "square.and.arrow.up")
                }
            }
            
            ToolbarItemGroup(placement: .navigation) {
                HStack {
                    Button { navigateToPreviousCombination() }
                    label: { Image(systemName: "chevron.left") }
                        .disabled(!hasPreviousCombination)
                    
                    Button { navigateToNextCombination() }
                    label: { Image(systemName: "chevron.right") }
                        .disabled(!hasNextCombination)
                }
            }
        }
        .onAppear { renderCombinationImage() }
        .onChange(of: combination) { renderCombinationImage() }
    }
    
    @ViewBuilder
    private func colorCombinationFrame(for color: ColorModel, using geometry: GeometryProxy) -> some View {
        Rectangle()
            .fill(color.color)
            .frame(maxWidth: .infinity, maxHeight: geometry.size.height / CGFloat(combination.colors.count))
            .overlay {
                VStack(alignment: .leading, spacing: 8) {
                    Text(color.name)
                        .font(.largeTitle)
                        .multilineTextAlignment(.leading)
                    
                    Text(color.hex)
                        .font(.headline)
                        .multilineTextAlignment(.leading)
                    
                    Text(color.rgb)
                        .font(.subheadline)
                        .multilineTextAlignment(.leading)
                    
                    Text(color.cmyk)
                        .font(.subheadline)
                        .multilineTextAlignment(.leading)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundStyle(color.color.contrastingTextColor())
                .padding(.leading)
            }
            .copyFormats(of: color)
    }
    
    @MainActor
    private func renderCombinationImage() {
        let combinationPageForImage = CombinationPage(combination: combination)
            .frame(width: 400, height: 700)
            .background(Color(UIColor.systemBackground))
        
        let renderer = ImageRenderer(content: combinationPageForImage)
        
        renderer.scale = displayScale
        
        if let uiImage = renderer.uiImage {
            shareImage = Image(uiImage: uiImage)
        }
    }
    
    private func navigateToPreviousCombination() {
        guard let prevCombination = previousCombination else { return }
        combination = prevCombination
    }
    
    private func navigateToNextCombination() {
        guard let nextComb = nextCombination else { return }
        combination = nextComb
    }
}
