//
//  QueryDefinition.swift
//  vitrivr-VR
//
//  Created by Florian Spiess on 23.12.2024.
//

import Foundation

struct ResultPair: Decodable, Encodable, Hashable {
    var segmentId: String
    var score: Double
}

struct QueryDefinition: Decodable, Encodable, Hashable {
    var database: String
    var similarityText: String?
    var ocrText: String?
    var segmentId: String?
    var limit: Int
    var results: [ResultPair]
}
