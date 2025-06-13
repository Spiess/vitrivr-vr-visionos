//
//  VideoView.swift
//  vitrivr-VR
//
//  Created by Florian Spiess on 28.12.2024.
//

import SwiftUI
import AVKit

struct VideoView: View {
    let database: String
    let objectId: String
    let startTime: Double
    
    @State var player: AVPlayer
    
    @State private var feedbackText: String = ""
    
    init(database: String, objectId: String, startTime: Double) {
        self.database = database
        self.objectId = objectId
        self.startTime = startTime
        
        self.player = AVPlayer(url: ResourceUtility.getVideoUrl(collection: database, objectId: objectId))
        player.seek(to: CMTime(seconds: startTime, preferredTimescale: 1))
    }
    
    var body: some View {
        VideoPlayer(player: player)
        if DresConfig.dresClient != nil {
            HStack {
                Button("Submit") {
                    Task {
                        var itemId = objectId
                        if database != "lhe" {
                            itemId = String(itemId.dropFirst(2))
                        }
                        let time = Int64(player.currentTime().seconds * 1000)
                        let result = try await DresConfig.dresClient?.submit(evaluationId: DresConfig.currentEvaluation, item: itemId, start: time, end: time)
                        print("Result of submit: \(result?.status ?? false) message: \(result?.description ?? "Unknown")")
                        feedbackText = result?.description ?? "Error parsing response"
                    }
                }
                
                Text(feedbackText)
            }
        }
    }
}

#Preview {
    VideoView(database: "v3c", objectId: "v_00001", startTime: 0)
}
