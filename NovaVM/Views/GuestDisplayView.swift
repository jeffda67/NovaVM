import SwiftUI

struct GuestDisplayView: View {
    let state: VMState

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 18)
                .fill(Color(red: 0.055, green: 0.065, blue: 0.09))
            VStack(spacing: 14) {
                Image(systemName: "display")
                    .font(.system(size: 42, weight: .light))
                    .foregroundStyle(.cyan)
                Text("Guest display").font(.title3.weight(.semibold))
                Text("The graphical desktop will appear here when the QEMU display bridge is integrated.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: 420)
                Text(state.title.uppercased())
                    .font(.caption2.weight(.bold))
                    .tracking(1.2)
                    .foregroundStyle(state.color)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 7)
                    .background(state.color.opacity(0.12), in: Capsule())
            }
            .padding(24)
        }
        .aspectRatio(4 / 3, contentMode: .fit)
        .accessibilityElement(children: .combine)
    }
}
