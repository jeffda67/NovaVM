import Foundation

struct VMProfile: Identifiable, Codable, Hashable {
    var id: UUID
    var name: String
    var operatingSystem: GuestOperatingSystem
    var architecture: String
    var memoryMiB: Int
    var cpuCores: Int

    init(id: UUID = UUID(), name: String, operatingSystem: GuestOperatingSystem,
         architecture: String = "ARM64", memoryMiB: Int = 2048, cpuCores: Int = 2) {
        self.id = id
        self.name = name
        self.operatingSystem = operatingSystem
        self.architecture = architecture
        self.memoryMiB = memoryMiB
        self.cpuCores = cpuCores
    }

    static let examples = [
        VMProfile(name: "Linux ARM64", operatingSystem: .linux),
        VMProfile(name: "Windows ARM64", operatingSystem: .windows, memoryMiB: 4096, cpuCores: 4)
    ]
}

enum GuestOperatingSystem: String, Codable, CaseIterable, Identifiable {
    case linux = "Linux"
    case windows = "Windows"
    case other = "Other"
    var id: String { rawValue }

    var systemImage: String {
        switch self {
        case .linux: return "terminal"
        case .windows: return "pc"
        case .other: return "desktopcomputer"
        }
    }
}
