//
//  ColorViewModel.swift
//  DCC
//
//  Created by Erik Sebastian de Erice Jerez on 25/6/25.
//

import SwiftUI

@Observable
final class ColorCombinationViewModel {
    var selectedTab: TabItem = .colors
    var swatches: [Swatch] = []
    var colorsBySwatch: [Int: [ColorModel]] = [:]
    var combinations: [Combination] = []
    var isShowingGrid: Bool = true
    var isShowingInfo: Bool = false
    var versionChecker = AppVersionChecker()
    
    var appVersion: String {
        guard let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else {
            return "Version unknown"
        }
        
        return "Version \(version)"
    }
    
    private let mapper: ColorMapperProtocol
    
    init(mapper: ColorMapperProtocol = ColorMapper()) {
        self.mapper = mapper
        loadData()
    }
    
    func getCombination(by id: Int) -> Combination? {
        return combinations.first { $0.id == id }
    }
}

private extension ColorCombinationViewModel {
    func loadData() {
        loadSwatches()
        loadColors()
        loadCombinations()
    }
    
    func loadSwatches() {
        guard let url = Bundle.main.url(forResource: "swatches", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let swatches = try? JSONDecoder().decode([Swatch].self, from: data) else {
            return
        }
        
        self.swatches = swatches
    }
    
    func loadColors() {
        guard let url = Bundle.main.url(forResource: "colors", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let colorsDecoded = try? JSONDecoder().decode([String: [ColorDTO]].self, from: data),
              let colorsDTO = colorsDecoded["colors"] else {
            return
        }
        
        let colorsBySwatch = mapper.map(colorsDTO)
        self.colorsBySwatch = Dictionary(grouping: colorsBySwatch, by: \.collectionId)
    }
    
    func loadCombinations() {
        let allColors = getAllColors()
        self.combinations = generateCombinations(from: allColors)
    }
    
    func generateCombinations(from colors: [ColorModel]) -> [Combination] {
        var combinations: [Combination] = []
        var processedCombinationIds: Set<Int> = []
        
        for color in colors {
            for combinationId in color.combinations {
                if !processedCombinationIds.contains(combinationId) {
                    processedCombinationIds.insert(combinationId)
                    
                    let colorsInCombination = findColorsInCombination(
                        combinationId: combinationId,
                        allColors: colors
                    )
                    
                    if !colorsInCombination.isEmpty {
                        let combination = Combination(
                            id: combinationId,
                            colors: colorsInCombination
                        )
                        
                        combinations.append(combination)
                    }
                }
            }
        }
        
        return combinations.sorted { $0.id < $1.id }
    }
    
    func findColorsInCombination(combinationId: Int, allColors: [ColorModel]) -> [ColorModel] {
        return allColors
            .filter { $0.combinations.contains(combinationId) }
            .sorted { $0.name < $1.name }
    }
    
    func getAllColors() -> [ColorModel] {
        return colorsBySwatch.values.flatMap { $0 }
    }
}
