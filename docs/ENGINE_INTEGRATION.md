# QEMU and graphical display integration

The app shell is independent of a specific QEMU build. The next milestone is a real engine adapter.

## Required architecture

1. Build or integrate a QEMU runtime for iOS/arm64 with the required device models and guest support.
2. Define a Swift-facing engine interface for create, configure, start, pause, resume, stop, and reset.
3. Implement a graphical display transport. Render the guest framebuffer in-app using a Metal-backed or otherwise performant surface. A serial console is not an acceptable substitute.
4. Forward touch, pointer, and keyboard events to guest input devices.
5. Add disk image creation/import, VM configuration persistence, and lifecycle/error handling.
6. Validate Linux ARM64 first, then Windows ARM64 where firmware, drivers, and licensing permit.

## JIT and iOS constraints

iOS does not allow an ordinary app to grant itself unrestricted JIT entitlements. Any JIT path must use a supported, user-authorized signing/debugging or helper workflow compatible with the target iPadOS version. Do not claim JIT is built in until tested on-device.

## Acceptance criteria

- A Linux ARM64 guest boots to its actual graphical desktop inside NovaVM.
- The screen updates continuously without relying on serial text output.
- Touch and keyboard input reach the guest.
- Pause/resume/stop report real engine state.
- Missing engine binaries produce a clear unavailable state rather than a fake running VM.
