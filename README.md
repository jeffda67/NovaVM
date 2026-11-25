# NovaVM

NovaVM is a native SwiftUI iPad app foundation for running ARM64 virtual machines with an in-app graphical display.

> **Current status:** this repository starts with the native app shell, VM profile model, guest display surface, and unsigned IPA CI pipeline. A QEMU runtime and its display/input bridge are **not yet integrated**. The display currently shows an explicit placeholder instead of pretending a guest is running.

## Goals

- Render a real Windows/Linux guest desktop inside the app (not a serial terminal).
- Start with ARM64 guests on Apple Silicon iPad hardware.
- Provide touch, keyboard, and pointer input.
- Manage VM profiles and virtual disk images.
- Add a real QEMU backend and framebuffer/display transport in a later integration step.
- Investigate supported JIT enablement paths separately; iOS cannot grant unrestricted JIT to itself.

## Repository layout

- `NovaVM/` — SwiftUI application source.
- `project.yml` — XcodeGen project definition.
- `.github/workflows/build-ipa.yml` — unsigned device IPA build.
- `docs/ENGINE_INTEGRATION.md` — QEMU/display/input integration plan.

## Build

The GitHub Actions workflow builds an **unsigned** iOS device IPA. It can be installed only through a compatible signing/sideloading workflow; it is not an App Store-signed IPA.

For a local build with XcodeGen installed:

```sh
brew install xcodegen
xcodegen generate
xcodebuild -project NovaVM.xcodeproj -scheme NovaVM -sdk iphoneos -configuration Release CODE_SIGNING_ALLOWED=NO build
```

## Important limitations

The initial scaffold does not boot guest operating systems yet. A genuine graphical VM requires a QEMU build configured for iOS/arm64 plus a working display and input bridge. The app intentionally reports the backend as unavailable until that work is completed.
