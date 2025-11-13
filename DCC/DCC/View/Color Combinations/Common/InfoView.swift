//
//  InfoView.swift
//  DCC
//
//  Created by Erik Sebastian de Erice Jerez on 13/11/25.
//

import SwiftUI

struct InfoView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.openURL) private var openURL
    @Environment(ColorCombinationViewModel.self) private var viewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 16) {
                        ForEach(InfoSection.allCases) { section in
                            cellForSection(section)
                        }
                    }
                    .padding()
                }
                
                Text(viewModel.appVersion)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .padding(.vertical)
            }
            .navigationTitle("Info")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle")
                            .accessibilityLabel("Close")
                    }
                    .frame(width: 44, height: 44)
                }
            }
            .tint(.primary)
        }
    }
    
    @ViewBuilder
    private func cellForSection(_ section: InfoSection) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Label(section.title, systemImage: section.image)
                .labelStyle(.info(color: section.color))
            
            Text(section.description)
                .font(.subheadline)
            
            if section == .about {
                Button {
                    openURL(InfoSection.learnMoreURL)
                } label: {
                    Text("Learn more")
                        .font(.subheadline.bold())
                        .underline()
                }
                .buttonStyle(.plain)
            }
        }
        .padding()
        .background(section.color.opacity(0.2), in: .rect(cornerRadius: 8))
    }
}
