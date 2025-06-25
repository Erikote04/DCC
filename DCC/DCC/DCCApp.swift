//
//  DCCApp.swift
//  DCC
//
//  Created by Erik Sebastian de Erice Jerez on 25/6/25.
//

import SwiftUI

@main
struct DCCApp: App {
    @StateObject private var viewModel = ColorViewModel()
    
    var body: some Scene {
        WindowGroup {
            SwatchesView()
                .environmentObject(viewModel)
        }
    }
}
