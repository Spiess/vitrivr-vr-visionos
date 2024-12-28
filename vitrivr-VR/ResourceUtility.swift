//
//  ResourceUtility.swift
//  vitrivr-VR
//
//  Created by Florian Spiess on 27.12.2024.
//

import Foundation

struct ResourceUtility {
    static let resourceHost = "http://dmi-21-pc-02.local:8090"
    
    static func getThumbnailUrl(collection: String, segmentId: String) -> URL {
        if (collection == "lhe") {
            return URL(string: "\(resourceHost)/\(collection)/thumbnails/\(segmentId).jpg")!
        }
        // Remove last _ and remaining part of segmentId for objectId
        let lastUnderscoreIndex = segmentId.lastIndex(of: "_")
        let objectId = String(segmentId[..<lastUnderscoreIndex!])
        return URL(string: "\(resourceHost)/\(collection)/thumbnails/\(objectId)/\(segmentId).jpg")!
    }
    
    static func getVideoUrl(collection: String, objectId: String) -> URL {
        switch collection {
        case "v3c":
            return URL(string: "\(resourceHost)/\(collection)/videos/\(objectId).mp4")!
        case "mvk":
            let videoId = String(objectId.dropFirst(2))
            return URL(string: "\(resourceHost)/\(collection)/videos/\(videoId).mp4")!
        case "lhe":
            return URL(string: "\(resourceHost)/\(collection)/videos/\(objectId).mp4")!
        default:
            return URL(string: "\(resourceHost)/\(collection)/videos/\(objectId).mp4")!
        }
    }
}
