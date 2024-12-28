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
    
    init(database: String, objectId: String, startTime: Double) {
        self.database = database
        self.objectId = objectId
        self.startTime = startTime
        
        self.player = AVPlayer(url: ResourceUtility.getVideoUrl(collection: database, objectId: objectId))
        player.seek(to: CMTime(seconds: startTime, preferredTimescale: 1))
    }
    
    var body: some View {
        VideoPlayer(player: player)
    }
}

#Preview {
    VideoView(database: "v3c", objectId: "v_00001", startTime: 0)
}
