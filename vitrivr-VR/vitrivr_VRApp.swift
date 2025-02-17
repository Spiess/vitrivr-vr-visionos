//
//  vitrivr_VRApp.swift
//  vitrivr-VR
//
//  Created by Florian Spiess on 23.12.2024.
//

import SwiftUI
import FereLightSwiftClient

@main
struct vitrivr_VRApp: App {
    
    private var ferelightClient: FereLightClient
    
    init() {
        ferelightClient = FereLightSwiftClient.FereLightClient(url: URL(string: "http://dmi-21-pc-02.local:8080")!)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(ferelightClient: ferelightClient)
        }.defaultSize(width: 800, height: 200)
        
        WindowGroup(for: QueryDefinition.self) { $qd in
            ResultView(queryDefinition: qd!, ferelightClient: ferelightClient)
        }
        
        WindowGroup(for: VideoSegment.self) { $vs in
            VideoView(database: vs!.database, objectId: vs!.objectId, startTime: vs!.start)
        }
        
        WindowGroup(id: "dres-config") {
            DresConfigView()
        }.defaultSize(width: 400, height: 300)
    }
}
