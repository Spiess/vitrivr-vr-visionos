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
    @State private var resultText: String = ""
    
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
            .padding(.horizontal, 20)
            
            Button("Search") {
                Task {
                    await search()
                }
            }
            Text("Results: " + resultText)
        }
        .padding()
    }
    
    func search() async {
        print("entering search")
        do {
            let result = try await ferelightClient.query(database: "v3c", similarityText: inputText, ocrText: nil, limit: 100)
            resultText = String(describing: result)
            openWindow(value: QueryDefinition(database: "v3c", similarityText: inputText, limit: 10, results: result.map {ResultPair(segmentId: $0.segmentId, score: $0.score)}))
        } catch {
            print("Error!")
        }
    }
}

#Preview(windowStyle: .automatic) {
    ContentView(ferelightClient: FereLightSwiftClient.FereLightClient(url: URL(string: "http://localhost:8080")!))
}
