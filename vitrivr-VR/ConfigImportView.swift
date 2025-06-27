import SwiftUI
import UniformTypeIdentifiers

struct ConfigImportView: View {
    @EnvironmentObject var configManager: ConfigManager
    @EnvironmentObject var clientManager: ClientManager
    @State private var isPickerPresented = false

    var body: some View {
        VStack(spacing: 20) {
            Text("Current Media Host:")
                .font(.headline)

            if let mediaHost = UserDefaults.standard.string(forKey: "media_host") {
                Text(mediaHost)
                    .font(.subheadline)
                    .foregroundColor(.green)
            } else {
                Text("Media host not set")
                    .foregroundColor(.red)
            }

            Button("Import Config File") {
                isPickerPresented = true
            }
            .fileImporter(
                isPresented: $isPickerPresented,
                allowedContentTypes: [.json],
                allowsMultipleSelection: false
            ) { result in
                switch result {
                case .success(let urls):
                    guard let selectedURL = urls.first else { return }

                    guard selectedURL.startAccessingSecurityScopedResource() else {
                        print("Failed to access security-scoped resource")
                        return
                    }

                    defer { selectedURL.stopAccessingSecurityScopedResource() }

                    let destURL = configManager.configFileURL()

                    do {
                        // Replace any existing config file
                        try? FileManager.default.removeItem(at: destURL)
                        try FileManager.default.copyItem(at: selectedURL, to: destURL)

                        configManager.loadConfig()
                        clientManager.createClients()
                    } catch {
                        print("Failed to copy config: \(error)")
                    }

                case .failure(let error):
                    print("Import failed: \(error)")
                }
            }
            
            Button(role: .destructive) {
                configManager.deleteConfig()
            } label: {
                Text("Delete Config File")
            }

        }
        .padding()
    }
}
