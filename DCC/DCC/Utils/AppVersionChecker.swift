//
//  AppVersionChecker.swift
//  DCC
//
//  Created by Erik Sebastian de Erice Jerez on 25/11/25.
//

import Foundation

@Observable
final class AppVersionChecker {
    var isUpdateAvailable: Bool = false
    var showUpdateAlert: Bool = false
    var latestVersion: String = ""
    private(set) var appStoreURL: URL?
    
    private let bundleId: String
    private let currentVersion: String
    private let appId: String = "6755197266"
    
    init(bundleId: String = "com.erikerice.Colors",
         currentVersion: String = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0") {
        self.bundleId = bundleId
        self.currentVersion = currentVersion
    }
    
    func checkForUpdate() async {
        guard let url = URL(string: "https://itunes.apple.com/lookup?bundleId=\(bundleId)") else {
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let response = try JSONDecoder().decode(AppStoreResponse.self, from: data)
            
            guard let result = response.results.first else {
                return
            }
            
            latestVersion = result.version
            
            let regionCode = Locale.current.region?.identifier.lowercased() ?? "es"
            appStoreURL = URL(string: "https://apps.apple.com/\(regionCode)/app/sanzo-palette/id\(appId)")
            
            if isVersionOutdated(current: currentVersion, latest: latestVersion) {
                await MainActor.run {
                    isUpdateAvailable = true
                    showUpdateAlert = true
                }
            }
        } catch {
            print("Error checking version: \(error.localizedDescription)")
        }
    }
    
    private func isVersionOutdated(current: String, latest: String) -> Bool {
        let currentComponents = current.split(separator: ".").compactMap { Int($0) }
        let latestComponents = latest.split(separator: ".").compactMap { Int($0) }
        let maxLength = max(currentComponents.count, latestComponents.count)
        
        for i in 0..<maxLength {
            let currentNum = i < currentComponents.count ? currentComponents[i] : 0
            let latestNum = i < latestComponents.count ? latestComponents[i] : 0
            return (latestNum > currentNum) ? true : false
        }
        
        return false
    }
}
