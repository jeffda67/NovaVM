# UTM/QEMU engine integration

## Why this path

Do not write a new QEMU iOS port from scratch. UTM maintains a Darwin/iOS QEMU fork, a SPICE frontend, an iOS display implementation, and a Metal rendering path. NovaVM should reuse that proven stack and then customize the product layer.

Pinned upstream revision: `utmapp/UTM@3d4b8d8cb1ce93a8b1a9610695c12487685f0c15`.

## Current branch contents

- `Vendor/UTM` is a Git submodule pinned to the revision above.
- The upstream source contains QEMU integration and its CocoaSpice/SPICE/Metal display and input path.
- `.github/workflows/build-utm-engine.yml` builds the upstream iOS ARM64 dependencies and UTM archive from source on a macOS runner.
- The build now uses GitHub's `xcode-27` runner because this pinned UTM revision references iOS 27 SDK APIs, including SwiftUI scene accessories. The earlier `macos-26` runner supplied Xcode 26.6 / iOS 26.x SDK and failed compiling those APIs.
- The workflow verifies that Xcode 27 and an iOS 27 SDK are selected before starting the long native dependency build.
- The resulting artifact is explicitly an **upstream UTM engine prototype**, not a NovaVM-branded app. It is a validation/build milestone; the current NovaVM SwiftUI shell is still not linked to the QEMU runtime.

Initialize source locally:

```sh
git submodule update --init --recursive
```

## Build and package the upstream engine

The workflow mirrors UTM's documented process:

```sh
cd Vendor/UTM
./scripts/build_dependencies.sh -p ios -a arm64
./scripts/build_utm.sh -k iphoneos -s iOS -a arm64 -o ../../build/utm
```

Then package the archive using UTM's own `scripts/package.sh ipa` mode. The CI artifact is unsigned and uses UTM's upstream bundle identifier/entitlements. It is **not** the final NovaVM app and is not signed for App Store distribution.

The workflow builds the full UTM app because the QEMU runtime, CocoaSpice display renderer, iOS touch/keyboard handling, VM model, helper components, and required resources are a coordinated application—not a standalone QEMU library that can safely be dropped into the current SwiftUI shell.

## Next NovaVM integration stages

1. Get the pinned upstream iOS build green and inspect its archive/IPA output.
2. Establish NovaVM's product boundary: initially use the upstream UTM runtime and frontend as the engine host, then replace branding and adapt its VM library/profile experience. Do not copy only `libqemu`; the display and input stack are required.
3. If retaining the separate SwiftUI shell, port the upstream VM model/configuration and UIKit display controller as a coordinated unit. Replace `GuestDisplayView` with the actual CocoaSpice Metal display, and connect lifecycle to `UTMQemuVirtualMachine`.
4. Wire touch gestures, pointer events, keyboard accessory input, display resize, disk import, and persistent VM bundle storage.
5. Rebrand app metadata/assets only after the engine app boots a guest.
6. Device smoke test: boot an ARM64 Linux image, verify desktop pixels render, verify touch/pointer and keyboard input, then test stop/restart and persistence.

## iOS constraints

- iOS does not expose Hypervisor.framework to third-party apps; QEMU uses software emulation/TCG on iOS.
- Fast TCG execution needs JIT. UTM documents a separate interpreter-based UTM SE build for devices without a supported JIT launch path.
- JIT behavior depends on iOS version, signing/debugger launch, and supported helper integrations. NovaVM must not promise JIT or virtualization acceleration until verified on the target iPad.
- The upstream docs note that on iOS 26+, helper tools such as `qemu-img` use an embedded ExtensionKit helper, with additional signing/provisioning requirements.

## Acceptance criteria

The NovaVM integration is not complete until all are true on a physical iPad:

- A real ARM64 guest boots.
- A graphical Linux/Windows desktop is visible inside NovaVM.
- Touch/pointer and keyboard input reach the guest.
- VM stop/restart works without corrupting the disk.
- The IPA is installable using the user's intended signing/sideloading method.
