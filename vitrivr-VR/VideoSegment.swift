//
//  VideoSegment.swift
//  vitrivr-VR
//
//  Created by Florian Spiess on 28.12.2024.
//

import Foundation

struct VideoSegment: Decodable, Encodable, Hashable {
    var database: String
    var objectId: String
    var start: Double
}
