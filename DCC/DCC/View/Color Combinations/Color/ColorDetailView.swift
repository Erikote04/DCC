//
//  ColorDetailView.swift
//  DCC
//
//  Created by Erik Sebastian de Erice Jerez on 26/6/25.
//

import SwiftUI

struct ColorDetailView: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.displayScale) var displayScale
    @Environment(ColorCombinationViewModel.self) private var viewModel
    
    let color: ColorModel
    
    @State private var shareImage = Image(systemName: "photo")
    @State private var showingShareDialog = false
    
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
                            if let combination = viewModel.getCombination(by: combinationId) {
                                NavigationLink(value: combination) {
                                    VStack {
                                        HStack(spacing: .zero) {
                                            CombinationRow(combination: combination)
                                                .padding(.vertical, 4)
                                            
                                            Image(systemName: "chevron.right")
                                                .font(.footnote.bold())
                                                .foregroundStyle(Color.gray)
                                                .frame(width: 24, height: 24)
                                                .padding(.trailing, 8)
                                        }
                                        
                                        Divider()
                                            .padding(.leading)
                                    }
                                }
                            }
                        }
                    } header: {
                        detailHeader(for: color)
                    }
                }
            }
        }
        .navigationTitle(color.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(backgroundColor)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    showingShareDialog = true
                } label: {
                    Image(systemName: "square.and.arrow.up")
                }
            }
        }
        .onAppear { renderColorImage() }
        .onChange(of: color) { renderColorImage() }
        .confirmationDialog(
            Text("How do you want to share this color?"),
            isPresented: $showingShareDialog,
            titleVisibility: .visible
        ) {
            ShareLink(
                item: shareImage,
                preview: SharePreview(
                    "Color: \(color.name)",
                    image: shareImage
                )
            ) {
                Text("Plain Color")
            }
            
            ShareLink(
                item: renderColorDataImage(),
                preview: SharePreview(
                    "Color Data: \(color.name)",
                    image: renderColorDataImage()
                )
            ) {
                Text("Color Data")
            }
        }
    }
    
    @ViewBuilder
    private func detailHeader(for color: ColorModel) -> some View {
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
    
    @MainActor
    private func renderColorImage() {
        let plainColorForImage = PlainColor(color: color.color)
            .frame(width: 400, height: 700)
            .background(Color(UIColor.systemBackground))
        
        let renderer = ImageRenderer(content: plainColorForImage)
        
        renderer.scale = displayScale
        
        if let uiImage = renderer.uiImage {
            shareImage = Image(uiImage: uiImage)
        }
    }
    
    @MainActor
    private func renderColorDataImage() -> Image {
        let colorDataForImage = ColorData(color: color)
            .frame(width: 400, height: 700)
            .background(Color(UIColor.systemBackground))
        
        let renderer = ImageRenderer(content: colorDataForImage)
        
        renderer.scale = displayScale
        
        if let uiImage = renderer.uiImage {
            return Image(uiImage: uiImage)
        }
        
        return Image(systemName: "photo")
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
    .environment(ColorCombinationViewModel())
    .tint(.primary)
}
