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
    
    init() {
        // Register default values for settings
        UserDefaults.standard.register(defaults: [
            "media_host": "http://localhost:8000",
            "ferelight_host": "http://localhost:8080",
            "dres_enabled": false,
            "dres_host": "https://vbs.videobrowsing.org",
            "dres_user": "user",
            "dres_password": "password"
        ])
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(configManager)
                .environmentObject(clientManager)
                .onAppear {
                    clientManager.createClients()
                }
                .task {
                    if UserDefaults.standard.bool(forKey: "dres_enabled") {
                        do {
                            try await DresConfig.login()
                        } catch {
                            print("Error logging into DRES: \(error)")
                        }
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
        }.defaultSize(width: 500, height: 500)
    }
}
