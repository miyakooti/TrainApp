//
//  TrainSearchResult.swift
//  trainApp
//
//  Created by Arai Kousuke on 2021/10/15.
//

import Foundation

struct TrainSearchResult: Codable {
    let ResultSet: ResultSet
}

// MARK: - ResultSet
struct ResultSet: Codable {
    let ApiVersion: String?
    let EngineVersion: String?
    let ResourceURI: String?
}
