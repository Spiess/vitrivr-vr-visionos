//
//  DresConfigView.swift
//  vitrivr-VR
//
//  Created by Florian Spiess on 28.12.2024.
//

import SwiftUI

struct DresConfigView: View {
    @State private var loggedIn: Bool = false
    @State private var evaluations: [EvaluationData]
    @State private var evaluation: String
    
    init() {
        loggedIn = DresConfig.dresClient != nil
        evaluations = DresConfig.evaluations
        evaluation = DresConfig.currentEvaluation
    }
    
    var body: some View {
        Text("DRES URL: \(DresConfig.dresUrl)")
        Text("DRES User: \(DresConfig.dresUser)")
        Text("Logged In: \(loggedIn)")
        
        Button("Log In") {
            Task {
                do {
                    try await DresConfig.login()
                    loggedIn = DresConfig.dresClient != nil
                }
                catch {
                    print("Error logging in DRES: \(error)")
                }
            }
        }
        
        HStack {
            Picker("Evaluation", selection: $evaluation) {
                ForEach(evaluations, id: \.self) { evaluation in
                    Text(evaluation.name).tag(evaluation.id)
                }
            }.onChange(of: evaluation) { oldEvaluation, newEvaluation in
                DresConfig.currentEvaluation = newEvaluation
            }
            Button("Update Evaluations") {
                Task {
                    do {
                        try await DresConfig.updateEvaluations()
                        evaluations = DresConfig.evaluations
                        evaluation = evaluations.first?.id ?? ""
                    }
                    catch {
                        print("Error logging in DRES: \(error)")
                    }
                }
            }
        }
    }
}

#Preview {
    DresConfigView()
}
