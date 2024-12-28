//
//  ContentView.swift
//  vitrivr-VR
//
//  Created by Florian Spiess on 23.12.2024.
//

import SwiftUI
import RealityKit
import RealityKitContent
import FereLightSwiftClient

struct ContentView: View {
    @State private var inputText: String = ""
    
    @Environment(\.openWindow) private var openWindow
    
    private var ferelightClient: FereLightClient
    
    init(ferelightClient: FereLightClient) {
        self.ferelightClient = ferelightClient
    }
    
    var body: some View {
        VStack {
            TextField(
                    "Input text",
                    text: $inputText
                )
            .onSubmit {
                Task {
                    await search()
                }
            }
            .padding(.horizontal, 20)
            
            Button("Search") {
                Task {
                    await search()
                }
            }
        }
        .padding()
    }
    
    func search() async {
        do {
            let limit = 200
            let result = try await ferelightClient.query(database: "v3c", similarityText: inputText, ocrText: nil, limit: limit)
            openWindow(value: QueryDefinition(database: "v3c", similarityText: inputText, limit: limit, results: result.map {ResultPair(segmentId: $0.segmentId, score: $0.score)}))
        } catch {
            print("Error!")
        }
    }
}

#Preview(windowStyle: .automatic) {
    ContentView(ferelightClient: FereLightSwiftClient.FereLightClient(url: URL(string: "http://localhost:8080")!))
}
