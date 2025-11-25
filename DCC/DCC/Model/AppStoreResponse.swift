//
//  AppStoreResponse.swift
//  DCC
//
//  Created by Erik Sebastian de Erice Jerez on 25/11/25.
//

import Foundation

struct AppStoreResponse: Codable {
    let results: [AppStoreResult]
}

struct AppStoreResult: Codable {
    let version: String
    let trackId: Int
}
