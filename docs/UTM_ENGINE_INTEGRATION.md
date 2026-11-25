# UTM/QEMU engine integration

## Why this path

Do not write a new QEMU iOS port from scratch. UTM already maintains an iOS QEMU build, a SPICE frontend, an iOS display implementation, and a Metal rendering path. NovaVM should reuse that proven stack and then customize the product layer.

Pinned upstream revision: `utmapp/UTM@3d4b8d8cb1ce93a8b1a9610695c12487685f0c15`.

## What is present in this branch

- `Vendor/UTM` is a Git submodule pinned to the revision above.
- The upstream source contains the QEMU integration and its CocoaSpice/SPICE/Metal display path.
- The existing NovaVM SwiftUI shell remains separate and is not yet connected to that runtime.

Initialize the source with:

```sh
git submodule update --init --recursive
```

## Build the upstream iOS engine/app

Use a current macOS/Xcode environment. UTM's own documented process is:

1. Clone recursively or initialize all submodules.
2. Obtain the matching `Sysroot-ios-arm64` dependency artifact from UTM's Actions artifacts and extract it into the UTM checkout root.
3. Build the iOS archive:

```sh
cd Vendor/UTM
./scripts/build_utm.sh -k iphoneos -s iOS -a arm64 -o ../../build/utm
```

4. Package the resulting archive using UTM's `scripts/package.sh`. An unsigned package still requires a supported sideloading/install path; a normal signed build requires the appropriate development signing setup and helper profile.

Refer to the pinned upstream `Documentation/iOSDevelopment.md` for the exact current dependency artifact, signing, helper-extension, and JIT requirements.

## Required NovaVM port work (not yet complete)

1. Decide the integration boundary: use UTM's app/runtime as the engine host, or extract its QEMU/SPICE/Metal targets into NovaVM. Do not try to link only `libqemu`; the display and input stack are required too.
2. Replace the placeholder `GuestDisplayView` with the actual iOS display view/controller from the upstream CocoaSpice implementation, preserving the Metal-backed IOSurface rendering path.
3. Connect VM profile lifecycle to UTM's VM model/configuration and QEMU launch API.
4. Wire touch gestures, pointer events, keyboard accessory input, and display resize through the upstream SPICE input path.
5. Add VM bundle/disk import and persistent storage handling.
6. Rebrand app metadata and assets only after the engine app builds and boots a guest.
7. Add a device smoke test: boot an ARM64 Linux image, verify desktop pixels render, verify touch/pointer and keyboard input, then test stop/restart and persistence.

## JIT and performance

QEMU's fast TCG path requires JIT. UTM documents separate iOS paths and a slower interpreter-based UTM SE variant. JIT behavior depends on iOS version, signing/debugger launch, and supported helper integrations; NovaVM must not promise JIT or virtualization acceleration until verified on the target iPad.

## Acceptance criteria

This integration is not complete until all are true on a physical iPad:

- A real ARM64 guest boots.
- A graphical desktop is visible inside NovaVM.
- Touch/pointer and keyboard input reach the guest.
- VM stop/restart works without corrupting the disk.
- The IPA is built and installable using the user's intended signing method.

A green CI check for the SwiftUI shell alone does not satisfy these criteria.
