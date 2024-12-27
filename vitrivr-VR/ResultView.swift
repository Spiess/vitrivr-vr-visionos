//
//  ResultView.swift
//  vitrivr-VR
//
//  Created by Florian Spiess on 23.12.2024.
//

import SwiftUI
import FereLightSwiftClient

struct ResultView: View {
    let queryDefinition: QueryDefinition
    let ferelightClient: FereLightClient
    let numResults: Int
        
    init(queryDefinition: QueryDefinition, ferelightClient: FereLightClient) {
        self.queryDefinition = queryDefinition
        self.ferelightClient = ferelightClient
        self.numResults = queryDefinition.results.count
    }
    
    private func getThumbnailURL(segmentId: String) -> URL {
        // Remove last _ and remaining part of segmentId for objectId
        let lastUnderscoreIndex = segmentId.lastIndex(of: "_")
        let objectId = String(segmentId[..<lastUnderscoreIndex!])
        return URL(string: "http://dmi-21-pc-02.local:8090/v3c/thumbnails/\(objectId)/\(segmentId).jpg")!
    }
    
    var body: some View {
        ScrollView {
            VStack {
                Text("Results")
                    .font(.headline)
                    .padding()
                ForEach(0..<numResults, id: \.self) {i in
                    AsyncImage(url: getThumbnailURL(segmentId: queryDefinition.results[i].segmentId)).scaledToFit()
                        .onTapGesture {
                            Task {
                                await openSegment(segmentID: queryDefinition.results[i].segmentId)
                            }
                        }
                }
            }
        }
    }
    
    func openSegment(segmentID: String) async {
        print(segmentID)
    }
}

#Preview {
    ResultView(queryDefinition: QueryDefinition(database: "v3c", similarityText: "Test", limit: 10, results: [ResultPair(segmentId: "v_00001_1", score: 0.5)]), ferelightClient: FereLightSwiftClient.FereLightClient(url: URL(string: "http://localhost:8080")!))
}
