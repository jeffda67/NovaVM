# NovaVM

NovaVM is a native iPad app project targeting ARM64 virtual machines with a real in-app graphical guest display.

> **Status:** the existing SwiftUI shell builds, but it is not yet a functioning VM. The QEMU runtime and guest display/input path are not wired into the app. This branch adds the upstream UTM/QEMU codebase as a pinned submodule so the engine integration is based on a proven iOS implementation rather than a placeholder or a fresh, incomplete QEMU port.

## Engine foundation

- Upstream engine/frontend: [UTM](https://github.com/utmapp/UTM), pinned as a Git submodule at `Vendor/UTM`.
- UTM is based on QEMU and already has an iOS guest display, SPICE input path, and Metal rendering implementation.
- The next integration work is to adapt the UTM iOS application/runtime into NovaVM's app identity and VM-profile experience. Merely adding the submodule does **not** mean QEMU is linked into NovaVM yet.

## Goals

- Show the actual Windows/Linux guest desktop in-app, never a terminal-only substitute.
- ARM64 guests first on Apple Silicon iPad.
- Touch, keyboard, pointer, VM lifecycle, and disk-image management.
- Investigate JIT separately. iOS does not allow an app to self-grant unrestricted JIT.

## Build status

The existing GitHub Actions workflow builds the SwiftUI scaffold as an unsigned IPA. It does not yet build or package the UTM/QEMU engine. Follow the pinned UTM iOS build instructions in `Vendor/UTM/Documentation/iOSDevelopment.md` and the integration notes in `docs/UTM_ENGINE_INTEGRATION.md`.

An unsigned IPA is not App Store-signed. Device installation requires a compatible signing/sideloading method.

## License

UTM is Apache-2.0, but its dependency tree includes components under other licenses (including LGPL/GPL components). Review and preserve all upstream notices and comply with the licenses before distributing a NovaVM build that incorporates those components.
