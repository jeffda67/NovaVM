# NovaVM

NovaVM is a native iPad VM project targeting ARM64 guests with a real graphical desktop rendered inside the app.

> **Current status:** the SwiftUI shell builds. The QEMU runtime is not yet connected to NovaVM's shell. The integration branch pins upstream UTM/QEMU and adds a CI workflow that builds the complete upstream UTM iOS app as an engine-validation artifact. That artifact is UTM, not yet the final NovaVM-branded app.

## Engine foundation

- Upstream engine/frontend: [UTM](https://github.com/utmapp/UTM), pinned at `Vendor/UTM`.
- QEMU supplies system emulation; CocoaSpice/SPICE and Metal provide the graphical display and input path.
- See `docs/UTM_ENGINE_INTEGRATION.md` for the integration plan and iOS constraints.

## Build validation

Run **Build UTM iOS Engine Prototype** from the Actions tab (or push to `integration/utm-qemu-base`). It builds UTM's iOS ARM64 dependencies, QEMU/SPICE stack, and upstream iOS app archive, then uploads an unsigned engine-prototype IPA and archive.

The prototype retains UTM's upstream app identity and is not the final NovaVM app. The existing `Build NovaVM IPA` workflow only builds the SwiftUI shell.

## Goals

- Actual Windows/Linux graphical desktop in-app, not a terminal-only substitute.
- ARM64 guests first on Apple Silicon iPad.
- Touch, keyboard, pointer, VM lifecycle, and disk-image management.
- Honest JIT/performance support based on the device's actual signing and launch path.

## Signing and licensing

Unsigned packages are not App Store-signed. Installation requires a compatible sideloading method; privileged entitlements/JIT behavior cannot be assumed on stock iPadOS.

UTM is Apache-2.0, but its dependency tree includes components under other licenses (including LGPL/GPL components). Preserve upstream notices and comply with all applicable licenses before distributing a NovaVM build that incorporates those components.
