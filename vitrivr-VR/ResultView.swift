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
    
    @Environment(\.openWindow) private var openWindow
        
    init(queryDefinition: QueryDefinition, ferelightClient: FereLightClient) {
        self.queryDefinition = queryDefinition
        self.ferelightClient = ferelightClient
        self.numResults = queryDefinition.results.count
        print("Results: \(numResults)")
    }
    
    var body: some View {
        ScrollView {
            VStack {
                Text("Results")
                    .font(.headline)
                    .padding()
                ForEach(0..<numResults, id: \.self) {i in
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
    
    func openSegment(segmentID: String) async {
        print(segmentID)
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
