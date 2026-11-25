import SwiftUI

@main
struct NovaVMApp: App {
    @StateObject private var vmManager = VMManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(vmManager)
                .preferredColorScheme(.dark)
        }
    }
}
