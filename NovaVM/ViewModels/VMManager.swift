import Foundation
import SwiftUI

@MainActor
final class VMManager: ObservableObject {
    @Published var profiles: [VMProfile] = VMProfile.examples
    @Published var selectedProfileID: UUID?
    @Published private(set) var state: VMState = .stopped
    @Published private(set) var statusMessage = "Virtualization engine not installed"

    init() { selectedProfileID = profiles.first?.id }

    var selectedProfile: VMProfile? {
        profiles.first { $0.id == selectedProfileID }
    }

    func start() {
        // Do not fake a boot: connect this to the QEMU adapter when implemented.
        state = .unavailable
        statusMessage = "QEMU engine integration is not installed yet."
    }

    func stop() {
        state = .stopped
        statusMessage = "VM stopped"
    }
}

enum VMState {
    case stopped, starting, running, paused, unavailable

    var title: String {
        switch self {
        case .stopped: return "Stopped"
        case .starting: return "Starting"
        case .running: return "Running"
        case .paused: return "Paused"
        case .unavailable: return "Engine unavailable"
        }
    }

    var color: Color {
        switch self {
        case .running: return .green
        case .starting: return .orange
        case .unavailable: return .red
        case .stopped, .paused: return .secondary
        }
    }
}
