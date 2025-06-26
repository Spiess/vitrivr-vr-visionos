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
    
    @StateObject private var configManager = ConfigManager()
    @StateObject private var clientManager = ClientManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(configManager)
                .environmentObject(clientManager)
                .onAppear {
                    if let config = configManager.config{
                        clientManager.createClients(with: config)
                    }
                }
        }.defaultSize(width: 800, height: 200)
        
        WindowGroup(for: QueryDefinition.self) { $qd in
            ResultView(queryDefinition: qd!)
                .environmentObject(clientManager)
        }
        
        WindowGroup(for: VideoSegment.self) { $vs in
            VideoView(database: vs!.database, objectId: vs!.objectId, startTime: vs!.start)
        }
        
        WindowGroup(id: "config") {
            ConfigImportView()
                .environmentObject(configManager)
                .environmentObject(clientManager)
        }.defaultSize(width: 300, height: 200)
        
        WindowGroup(id: "dres-config") {
            DresConfigView()
        }.defaultSize(width: 400, height: 300)
    }
}
