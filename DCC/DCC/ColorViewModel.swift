//
//  ColorViewModel.swift
//  DCC
//
//  Created by Erik Sebastian de Erice Jerez on 25/6/25.
//

import SwiftUI

final class ColorViewModel: ObservableObject {
    @Published var swatches: [Swatch] = []
    @Published var colorsBySwatch: [Int: [Color]] = [:]
    
    private let mapper: ColorMapperProtocol
    
    init(mapper: ColorMapperProtocol = ColorMapper()) {
        self.mapper = mapper
        loadData()
    }
    
    private func loadData() {
        loadSwatches()
        loadColors()
    }
    
    private func loadSwatches() {
        guard let url = Bundle.main.url(forResource: "swatches", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let swatches = try? JSONDecoder().decode([Swatch].self, from: data) else {
            return
        }
        
        self.swatches = swatches
    }
    
    private func loadColors() {
        guard let url = Bundle.main.url(forResource: "colors", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let colorsDecoded = try? JSONDecoder().decode([String: [ColorDTO]].self, from: data),
              let colorsDTO = colorsDecoded["colors"] else {
            return
        }
        
        let colorsBySwatch = mapper.map(colorsDTO)
        self.colorsBySwatch = Dictionary(grouping: colorsBySwatch, by: \.swatchCollection)
    }
}
