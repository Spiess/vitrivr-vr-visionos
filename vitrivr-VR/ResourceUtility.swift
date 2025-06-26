//
//  ResourceUtility.swift
//  vitrivr-VR
//
//  Created by Florian Spiess on 27.12.2024.
//

import Foundation

struct ResourceUtility {
    static var config: Config?
    
    static func getThumbnailUrl(collection: String, segmentId: String) -> URL {
        // Remove last _ and remaining part of segmentId for objectId
        let lastUnderscoreIndex = segmentId.lastIndex(of: "_")
        let objectId = String(segmentId[..<lastUnderscoreIndex!])

        
        let path = config!.collections[collection]!.thumbnailPattern
            .replacingOccurrences(of: ":c", with: collection)
            .replacingOccurrences(of: ":id", with: segmentId)
            .replacingOccurrences(of: ":oid", with: objectId)
        return URL(string: "\(config!.mediaHost)/\(path)")!
    }
    
    static func getVideoUrl(collection: String, objectId: String) -> URL {
        let path = config!.collections[collection]!.mediaPattern
            .replacingOccurrences(of: ":c", with: collection)
            .replacingOccurrences(of: ":oid", with: objectId)
        return URL(string: "\(config!.mediaHost)/\(path)")!
    }
}
