//
//  ResourceUtility.swift
//  vitrivr-VR
//
//  Created by Florian Spiess on 27.12.2024.
//

import Foundation

struct ResourceUtility {
    static func getThumbnailUrl(collection: String, segmentId: String) -> URL {
        // Remove last _ and remaining part of segmentId for objectId
        let lastUnderscoreIndex = segmentId.lastIndex(of: "_")
        let objectId = String(segmentId[..<lastUnderscoreIndex!])
        return URL(string: "http://dmi-21-pc-02.local:8090/\(collection)/thumbnails/\(objectId)/\(segmentId).jpg")!
    }
}
