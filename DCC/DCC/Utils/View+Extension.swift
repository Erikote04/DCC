//
//  View+Extension.swift
//  DCC
//
//  Created by Erik Sebastian de Erice Jerez on 7/7/25.
//

import SwiftUI
import UIKit

extension View {
    func copyFormats(of color: ColorModel) -> some View {
        self
            .contextMenu {
                Button("Copy Name") {
                    copyToClipboard(color.name)
                }
                
                Button("Copy HEX") {
                    copyToClipboard(color.hex)
                }
                
                Button("Copy RGB") {
                    copyToClipboard(color.rgb)
                }
                
                Button("Copy CMYK") {
                    copyToClipboard(color.cmyk)
                }
            }
    }
}

private func copyToClipboard(_ text: String) {
    UIPasteboard.general.string = text
}
