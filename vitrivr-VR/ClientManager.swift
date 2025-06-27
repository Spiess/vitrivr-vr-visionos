//
//  ClientManager.swift
//  vitrivr-VR
//
//  Created by Florian Spiess on 24.06.2025.
//

import Foundation
import FereLightSwiftClient


class ClientManager: ObservableObject {
    @Published var ferelightClient: FereLightClient?

    func createClients() {
        ferelightClient = FereLightSwiftClient.FereLightClient(url: URL(string: UserDefaults.standard.string(forKey: "ferelight_host")!)!)
    }
}
