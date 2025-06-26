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
    @State private var ocrText: String = ""
    @State private var collection: String = ""
    @State private var limit: Int = 200
    
    @State private var submissionText: String = ""
    
    @Environment(\.openWindow) private var openWindow
    
    @EnvironmentObject var configManager: ConfigManager
    @EnvironmentObject var clientManager: ClientManager
    
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
            TextField(
                    "OCR text",
                    text: $ocrText
                )
            .onSubmit {
                Task {
                    await search()
                }
            }
            .padding(.horizontal, 20)
            
            HStack {
                Text("Collection: ")
                Picker("Collection", selection: $collection) {
                    ForEach(Array(configManager.config!.collections.keys), id: \.self) { cid in
                        if let params = configManager.config!.collections[cid] {
                            Text(params.name).tag(cid)
                        }
                    }
                }
                .onAppear {
                    if collection.isEmpty {
                        collection = configManager.config!.collections.keys.first!
                    }
                }
                .onChange(of: configManager.config?.collections.keys.first) {
                    collection = configManager.config!.collections.keys.first!
                }
                Text("Results: ")
                Picker("Limit", selection: $limit) {
                    Text("40").tag(40)
                    Text("200").tag(200)
                    Text("500").tag(500)
                    Text("1000").tag(1000)
                }
                Button("Search") {
                    Task {
                        await search()
                    }
                }
            }
            
            Spacer()
                .frame(height: 20)
            
            HStack {
                Button("Config") {
                    openWindow(id: "config")
                }
                Button("DRES Config") {
                    openWindow(id: "dres-config")
                }
                TextField(
                        "Submit text",
                        text: $submissionText
                    )
                .onSubmit {
                    Task {
                        await submitText()
                    }
                }
                .padding(.horizontal, 20)
                Button("Submit Text") {
                    Task {
                        await submitText()
                    }
                }
            }
        }
        .padding()
    }
    
    func search() async {
        do {
            let ocrTextInput = ocrText.isEmpty ? nil : ocrText
            let result = try await clientManager.ferelightClient!.query(database: collection, similarityText: inputText, ocrText: ocrTextInput, limit: limit)
            openWindow(value: QueryDefinition(database: collection, similarityText: inputText, limit: limit, results: result.map {ResultPair(segmentId: $0.segmentId, score: $0.score)}))
        } catch {
            print("Error during search!")
        }
    }
    
    func submitText() async {
        do {
            let result = try await DresConfig.dresClient?.submitText(evaluationId: DresConfig.currentEvaluation, text: submissionText)
            print("Result of submit: \(result?.status ?? false) message: \(result?.description ?? "Unknown")")
        } catch {
            print("Error submitting text!")
        }
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
}
