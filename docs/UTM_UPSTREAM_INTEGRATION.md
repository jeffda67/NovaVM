# UTM/QEMU engine integration

## Upstream source

NovaVM now tracks the upstream UTM source as a Git submodule at `Vendor/UTM`.

- Upstream: https://github.com/utmapp/UTM
- Pinned revision: `3d4b8d8cb1ce93a8b1a9610695c12487685f0c15`
- Upstream iOS development guide: https://github.com/utmapp/UTM/blob/main/Documentation/iOSDevelopment.md

Initialize it with:

```sh
git submodule update --init --recursive
```

## Important: source is not yet linked into the NovaVM app

Adding upstream source does not, by itself, add QEMU to NovaVM or make a bootable VM. UTM is a full application with a large dependency graph, generated sources, build scripts, helper targets, QEMU, SPICE, and a Metal display stack. The current NovaVM XcodeGen target still builds only the SwiftUI shell. The submodule is a pinned source dependency for the next integration work, not a claim that the engine is already functional.

## Integration milestones

1. Build the upstream iOS ARM64 dependency sysroot and UTM targets in a macOS/Xcode environment. The upstream guide recommends using the matching `Sysroot-ios-arm64` CI artifact; building dependencies from source requires macOS, Xcode, Homebrew, and additional tools.
2. Audit the exact licenses of QEMU and every linked dependency. UTM's main repository is Apache-2.0, but its README explicitly warns that it uses several (L)GPL components. Preserve upstream notices and satisfy the applicable source-distribution and relinking obligations before redistributing binaries.
3. Choose the app integration boundary. Either adapt UTM's iOS application target and rebrand it as NovaVM, or extract a maintainable engine framework. Do not attempt to compile the entire UTM source tree by simply adding it to the existing XcodeGen `sources` list.
4. Connect NovaVM's VM profile and lifecycle UI to the engine's create/configure/start/pause/resume/stop APIs.
5. Integrate the Metal/SPICE guest display and touch, pointer, and keyboard input. Keep the display graphical; a serial terminal is not an acceptable replacement.
6. Add ARM64 Linux boot validation first, then evaluate Windows ARM64 firmware and driver support.
7. Verify on a physical iPad. JIT acceleration on iOS has separate entitlement and launch constraints; do not promise JIT performance unless the actual install and launch path is tested.

## Build environment constraint

The existing NovaVM build can produce the small unsigned SwiftUI shell. The upstream UTM build guide requires Xcode on macOS and prebuilt iOS ARM64 sysroot artifacts (or a macOS dependency build). A Linux Cloud Shell alone cannot compile these iOS dependencies. A remote Xcode build runner must also fetch the Git submodule recursively and make the matching sysroot artifact available.

## Acceptance criteria

- A Linux ARM64 guest reaches its real graphical desktop inside NovaVM.
- The display updates continuously through the Metal-backed display path.
- Touch and keyboard input reach the guest.
- VM lifecycle controls reflect actual engine state.
- No UI claims a guest is running until QEMU confirms it.
