//
//  DCCApp.swift
//  DCC
//
//  Created by Erik Sebastian de Erice Jerez on 25/6/25.
//

import SwiftUI

@main
struct DCCApp: App {
    @State private var viewModel = ColorCombinationViewModel()
    
    var body: some Scene {
        WindowGroup {
            ColorCombinationView(viewModel: viewModel)
                .environment(viewModel)
        }
    }
}
