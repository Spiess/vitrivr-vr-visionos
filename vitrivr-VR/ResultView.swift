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
    
    let resultColumns: Int = 5
    let resultRows: Int
    
    
    @Environment(\.openWindow) private var openWindow
        
    init(queryDefinition: QueryDefinition, ferelightClient: FereLightClient) {
        self.queryDefinition = queryDefinition
        self.ferelightClient = ferelightClient
        self.numResults = queryDefinition.results.count
        self.resultRows = Int(ceil(Double(numResults) / Double(resultColumns)))
    }
    
    var body: some View {
        ScrollView {
            VStack {
                Text("Results")
                    .font(.headline)
                    .padding()
                Grid {
                    ForEach(0..<resultRows, id: \.self) {row in
                        GridRow {
                            ForEach(0..<resultColumns, id: \.self) {column in
                                let i = row * resultColumns + column
                                if i >= numResults {
                                    Spacer()
                                } else {
                                    AsyncImage(url: ResourceUtility.getThumbnailUrl(collection: queryDefinition.database, segmentId: queryDefinition.results[i].segmentId)).scaledToFit()
                                        .onTapGesture {
                                            Task {
                                                await openSegment(segmentID: queryDefinition.results[i].segmentId)
                                            }
                                        }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func openSegment(segmentID: String) async {
        do {
            let segmentInfo = try await ferelightClient.getSegmentInfo(database: queryDefinition.database, segmentId: segmentID)
            openWindow(value: VideoSegment(database: queryDefinition.database, objectId: segmentInfo.objectId, start: segmentInfo.segmentStartAbs))
        }
        catch {
            print("Error opening segment: \(error)")
        }
    }
}

#Preview {
    ResultView(queryDefinition: QueryDefinition(database: "v3c", similarityText: "Test", limit: 10, results: [ResultPair(segmentId: "v_00001_1", score: 0.5)]), ferelightClient: FereLightSwiftClient.FereLightClient(url: URL(string: "http://localhost:8080")!))
}
