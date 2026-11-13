# Build and release

## Windows

Use Visual Studio/MSBuild Release configurations for Win32 and x64. Build `D8Dll` and `D8Static`; confirm `D8SKF_GetDevSerialNumber` and required `SKF_*` entries are exported. Keep OpenSSL statically linked where configured.

## Linux

Prefer `linux/build_x64_libusb_existing.sh`, `linux/build_all_arch_libusb_existing.sh`, and `linux/build_all_arch_so.sh`. Use the toolchains under `<local SDK or checkout path>`. Check `file`, `readelf -Ws`, `readelf --version-info`, and `objdump -p` for architecture, exports, GLIBC ceiling, and absence of dynamic OpenSSL/libusb dependencies.

## macOS

Run `macos/build_macos_universal.sh` under WSL with `<local SDK or checkout path>`. Produce x86_64, arm64, and Universal 2 dylibs. Confirm both universal architectures and required exported symbols. OpenSSL is embedded.

## Release copy

Copy `SKF\D8Skf.h` as `SKF.h`, then each verified binary to its matching platform folder. Preserve established destination names, including lowercase `libD8_loongarch64.so`. Compute SHA-256 on source and destination and fail the release on any mismatch. Never substitute stale files for failed builds.
