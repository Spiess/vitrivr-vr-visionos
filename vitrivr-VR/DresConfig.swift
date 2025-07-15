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
    public static var dresClient: DresClient? = nil
    
    public static var evaluations: [EvaluationData] = [EvaluationData(name: "No Evaluation", id: "")]
    public static var currentEvaluation: String?
    
    public static func login() async throws {
        let dresUrl = UserDefaults.standard.string(forKey: "dres_host")!
        let dresUser = UserDefaults.standard.string(forKey: "dres_user")!
        let dresPassword = UserDefaults.standard.string(forKey: "dres_password")!
        
        dresClient = try await DresClient(url: URL(string: dresUrl)!, username: dresUser, password: dresPassword)
    }
    
    public static func updateEvaluations() async throws {
        if dresClient == nil {
            try await login()
        }
        let results = try await dresClient?.listEvaluations() ?? []
        evaluations = results.map {EvaluationData(name: $0.name, id: $0.id)}
    }
    
    public static func submit(item: String, start: Int64? = nil, end: Int64? = nil) async throws -> (status: Bool, description: String) {
        var submitEval = currentEvaluation
        if submitEval == nil {
            submitEval = try await updateAndGetFirstEvaluationId()
        }
        let result = try await DresConfig.dresClient?.submit(evaluationId: submitEval!, item: item, start: start, end: end)
        
        return result!
    }
    
    private static func updateAndGetFirstEvaluationId() async throws -> String {
        try await updateEvaluations()
        return evaluations.first!.id
    }
}
