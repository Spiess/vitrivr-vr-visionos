//
//  Config.swift
//  vitrivr-VR
//
//  Created by Florian Spiess on 24.06.2025.
//

import Foundation


struct Config: Codable {
    let ferelightHost: String
    let mediaHost: String
    let collections: [String: CollectionConfig]
}

struct CollectionConfig: Codable {
    let name: String
    let thumbnailPattern: String
    let mediaPattern: String
}

class ConfigManager: ObservableObject {
    @Published var config: Config?

    private let configFileName = "config.json"

    init() {
        loadConfig()
    }

    func loadConfig() {
        let configURL = configFileURL()

        guard let data = try? Data(contentsOf: configURL),
              let decoded = try? JSONDecoder().decode(Config.self, from: data) else {
            print("Failed to load config, using default values")
            config = getDefaultConfig()
            ResourceUtility.config = config
            return
        }

        config = decoded
        ResourceUtility.config = config
        print("Loaded config: \(decoded)")
    }
    
    func getDefaultConfig() -> Config {
        return Config(
            ferelightHost: "localhost:8080",
            mediaHost: "localhost",
            collections: ["default": CollectionConfig(name: "Default", thumbnailPattern: ":c/thumbnails/:id.jpg", mediaPattern: ":c/videos/:oid.mp4")]
        )
    }
    
    func configFileURL() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                .appendingPathComponent(configFileName)
    }
    
    func deleteConfig() {
        let fileURL = configFileURL()

        do {
            if FileManager.default.fileExists(atPath: fileURL.path) {
                try FileManager.default.removeItem(at: fileURL)
                self.config = getDefaultConfig()
                print("Config deleted")
            } else {
                print("Config file does not exist")
            }
        } catch {
            print("Failed to delete config: \(error)")
        }
    }

}

