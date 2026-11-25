import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var vmManager: VMManager

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 22) {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Your virtual machines").font(.largeTitle.bold())
                        Text("Native iPad VM manager · ARM64").foregroundStyle(.secondary)
                    }
                    GuestDisplayView(state: vmManager.state)
                    HStack(spacing: 12) {
                        Button { vmManager.start() } label: {
                            Label("Start", systemImage: "play.fill").frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.cyan)
                        Button { vmManager.stop() } label: {
                            Label("Stop", systemImage: "stop.fill").frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.bordered)
                        .disabled(vmManager.state == .stopped)
                    }
                    .controlSize(.large)
                    profilePicker
                    VStack(alignment: .leading, spacing: 8) {
                        Text("ENGINE STATUS").font(.caption.weight(.bold)).foregroundStyle(.secondary)
                        Label(vmManager.statusMessage, systemImage: "info.circle")
                            .font(.subheadline).foregroundStyle(.secondary)
                        Text("This is the initial app foundation. Guest boot is not available until QEMU and the graphical display/input bridge are integrated.")
                            .font(.footnote).foregroundStyle(.secondary)
                    }
                    .padding(14)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(uiColor: .secondarySystemBackground), in: RoundedRectangle(cornerRadius: 14))
                }
                .padding()
                .frame(maxWidth: 900)
                .frame(maxWidth: .infinity)
            }
            .background(Color(uiColor: .systemBackground))
            .navigationTitle("NovaVM")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private var profilePicker: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("VM PROFILE").font(.caption.weight(.bold)).foregroundStyle(.secondary)
            ForEach(vmManager.profiles) { profile in
                Button { vmManager.selectedProfileID = profile.id } label: {
                    HStack(spacing: 12) {
                        Image(systemName: profile.operatingSystem.systemImage)
                            .font(.title2).frame(width: 40, height: 40)
                            .background(.quaternary, in: RoundedRectangle(cornerRadius: 10))
                        VStack(alignment: .leading, spacing: 3) {
                            Text(profile.name).font(.headline)
                            Text("\(profile.architecture) · \(profile.memoryMiB) MiB RAM · \(profile.cpuCores) cores")
                                .font(.caption).foregroundStyle(.secondary)
                        }
                        Spacer()
                        if vmManager.selectedProfileID == profile.id {
                            Image(systemName: "checkmark.circle.fill").foregroundStyle(.cyan)
                        }
                    }
                    .contentShape(Rectangle()).padding(12)
                    .background(vmManager.selectedProfileID == profile.id ? Color.cyan.opacity(0.09) : Color(uiColor: .secondarySystemBackground), in: RoundedRectangle(cornerRadius: 14))
                }
                .buttonStyle(.plain)
                .disabled(vmManager.state == .running || vmManager.state == .starting)
            }
        }
    }
}
