//
//  PhotoColorPickerViewModel.swift
//  DCC
//
//  Created by Erik Sebastian de Erice Jerez on 13/11/25.
//

import SwiftUI
import PhotosUI

@Observable
class PhotoColorPickerViewModel {
    var selectedImage: UIImage?
    var extractedColors: [PhotoColor] = []
    var isLoading = false
    var showImagePicker = false
    var showCamera = false
    var selectedItem: PhotosPickerItem?
    
    func processImage(_ image: UIImage) {
        selectedImage = image
        isLoading = true
        
        DispatchQueue.global(qos: .userInitiated).async {
            let colors = ColorExtractor.extractDominantColors(from: image, count: 8)
            
            DispatchQueue.main.async {
                self.extractedColors = colors
                self.isLoading = false
            }
        }
    }
    
    func resetView() {
        selectedImage = nil
        extractedColors = []
        selectedItem = nil
    }
}
