//
//  DresConfig.swift
//  vitrivr-VR
//
//  Created by Florian Spiess on 28.12.2024.
//

import Foundation
import DresSwiftClient

struct EvaluationData: Hashable {
    var name: String
    var id: String
}

struct DresConfig {
    public static var dresUrl: String = "https://vbs.videobrowsing.org"
    public static var dresUser: String = "02vitrivrVR"
    public static var dresPassword: String = "yuaZDFgUe4Kb"
    public static var dresClient: DresClient? = nil
    
    public static var evaluations: [EvaluationData] = [EvaluationData(name: "No Evaluation", id: "")]
    public static var currentEvaluation: String = ""
    
    public static func login() async throws {
        dresClient = try await DresClient(url: URL(string: dresUrl)!, username: dresUser, password: dresPassword)
    }
    
    public static func updateEvaluations() async throws {
        if dresClient == nil {
            try await login()
        }
        let results = try await dresClient?.listEvaluations() ?? []
        evaluations = results.map {EvaluationData(name: $0.name, id: $0.id)}
    }
}
