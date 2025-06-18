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

    @State private var visibleRows: Int = 1 // Start with the first row visible
    
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
                    ForEach(0..<resultRows, id: \.self) { row in
                        if row < visibleRows {
                            GridRow {
                                ForEach(0..<resultColumns, id: \.self) { column in
                                    let i = row * resultColumns + column
                                    if i >= numResults {
                                        Spacer()
                                    } else {
                                        ZStack(alignment: .topTrailing) {
                                            AsyncImage(url: ResourceUtility.getThumbnailUrl(collection: queryDefinition.database, segmentId: queryDefinition.results[i].segmentId)) { image in
                                                image.image?.resizable().scaledToFit()
                                            }
                                            .scaledToFit()
                                            .onAppear {
                                                // When the last image in this row appears, reveal the next row
                                                if column == resultColumns - 1 || i == numResults - 1 {
                                                    if visibleRows < resultRows {
                                                        DispatchQueue.main.async {
                                                            visibleRows += 1
                                                        }
                                                    }
                                                }
                                            }
                                            .onTapGesture {
                                                Task {
                                                    await openSegment(segmentID: queryDefinition.results[i].segmentId)
                                                }
                                            }
                                            Button(action: {
                                                Task {
                                                    await moreLikeThisSearch(segmentID: queryDefinition.results[i].segmentId)
                                                }
                                            }) {
                                                Image(systemName: "magnifyingglass")
                                                    .foregroundColor(.blue)
                                                    .padding(6)
                                                    .background(Color.white.opacity(0.8))
                                                    .clipShape(Circle())
                                                    .shadow(radius: 1)
                                            }
                                            .buttonStyle(PlainButtonStyle())
                                            .padding(4)
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
    
    func moreLikeThisSearch(segmentID: String) async {
        do {
            let result = try await ferelightClient.queryByExample(database: queryDefinition.database, segmentId: segmentID, limit: queryDefinition.limit)
            openWindow(value: QueryDefinition(database: queryDefinition.database, segmentId: segmentID, limit: queryDefinition.limit, results: result.map {ResultPair(segmentId: $0.segmentId, score: $0.score)}))
        } catch {
            print("Error during search!")
        }
    }
}

#Preview {
    ResultView(queryDefinition: QueryDefinition(database: "v3c", similarityText: "Test", limit: 10, results: [ResultPair(segmentId: "v_00001_1", score: 0.5)]), ferelightClient: FereLightSwiftClient.FereLightClient(url: URL(string: "http://localhost:8080")!))
}
