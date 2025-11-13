//
//  PhotoColorPickerView.swift
//  DCC
//
//  Created by Erik Sebastian de Erice Jerez on 13/11/25.
//

import SwiftUI
import PhotosUI

struct PhotoColorPickerView: View {
    @Environment(\.colorScheme) private var colorScheme
    
    @State private var selectedImage: UIImage?
    @State private var extractedColors: [PhotoColor] = []
    @State private var isLoading = false
    @State private var showImagePicker = false
    @State private var showCamera = false
    @State private var selectedItem: PhotosPickerItem?
    
    private var backgroundColor: Color {
        colorScheme == .dark ? .black : .white
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                if let image = selectedImage {
                    imageAnalysisSection(image: image)
                } else {
                    emptyStateSection
                }
            }
            .padding()
        }
        .navigationTitle("Color Scanner")
        .photosPicker(isPresented: $showImagePicker, selection: $selectedItem, matching: .images)
        .fullScreenCover(isPresented: $showCamera) {
            CameraView { image in
                processImage(image)
            }.ignoresSafeArea()
        }
        .onChange(of: selectedItem) { _, newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self),
                   let image = UIImage(data: data) {
                    processImage(image)
                }
            }
        }
    }
    
    @ViewBuilder
    private var emptyStateSection: some View {
        VStack(spacing: 30) {
            Image(systemName: "photo.on.rectangle.angled")
                .font(.system(size: 80))
                .foregroundStyle(.secondary)
                .padding(.top, 60)
            
            Text("Add a Photo")
                .font(.title2.bold())
            
            Text("Take a photo or select one from your library to extract its dominant colors")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            actionButtons
        }
    }
    
    @ViewBuilder
    private func imageAnalysisSection(image: UIImage) -> some View {
        VStack(spacing: 20) {
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .cornerRadius(12)
                .shadow(radius: 5)
            
            actionButtons
            
            if isLoading {
                ProgressView("Analyzing colors...")
                    .padding()
            } else if !extractedColors.isEmpty {
                colorsListSection
            }
        }
    }
    
    @ViewBuilder
    private var colorsListSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Extracted Colors")
                .font(.title2.bold())
                .frame(maxWidth: .infinity, alignment: .leading)
            
            ForEach(extractedColors) { color in
                PhotoColorRow(photoColor: color, showPercentage: true)
            }
        }
    }
    
    @ViewBuilder
    private var actionButtons: some View {
        VStack(spacing: 12) {
            if selectedImage != nil {
                Button {
                    resetView()
                } label: {
                    Label("Try Another", systemImage: "arrow.counterclockwise")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
            } else {
                HStack(spacing: 12) {
                    Button {
                        showCamera = true
                    } label: {
                        Label("Take Photo", systemImage: "camera.fill")
                            .frame(maxWidth: .infinity)
                            .foregroundStyle(colorScheme == .dark ? .black : .white)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(colorScheme == .dark ? .white : .black)
                    
                    Button {
                        showImagePicker = true
                    } label: {
                        Label("From Library", systemImage: "photo.fill")
                            .frame(maxWidth: .infinity)
                            .foregroundStyle(colorScheme == .dark ? .black : .white)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(colorScheme == .dark ? .white : .black)
                }
            }
        }
    }
    
    private func processImage(_ image: UIImage) {
        selectedImage = image
        isLoading = true
        
        DispatchQueue.global(qos: .userInitiated).async {
            let colors = ColorExtractor.extractDominantColors(from: image, count: 8)
            
            DispatchQueue.main.async {
                extractedColors = colors
                isLoading = false
            }
        }
    }
    
    private func resetView() {
        selectedImage = nil
        extractedColors = []
        selectedItem = nil
    }
}

#Preview {
    NavigationStack {
        PhotoColorPickerView()
    }
}
