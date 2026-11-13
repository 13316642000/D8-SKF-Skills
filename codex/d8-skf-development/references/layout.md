# Repository layout

Assume the repository root is `<local SDK or checkout path>` unless the user supplies another checkout.

## Authoritative sources

- `SKF\D8Skf.h` and `SKF\D8Skf.cpp`: public SKF ABI and main implementation.
- `D8Dll\D8Dll.vcxproj` and `D8Dll\D8Dll.def`: Windows DLL and exports.
- `D8Static\D8Static.vcxproj`: Windows static library.
- `linux\D8LibusbTransport.cpp`: Linux USB transport using bundled libusb.
- `linux\D8SKF.exports.map`: Linux exported-symbol policy.
- `macos\D8MacTransport.cpp`: macOS IOKit transport.
- `D8UserManagerV2`: resource-based MFC user-management and test tool.
- `可给用户自行编译`: customer-buildable Linux source package.

## Standard outputs

- Windows x86/x64: `bin\Win32\Release` and `bin\x64\Release`.
- Linux x64: `bin\linux\x86_64-glibc231\libD8_x64.so`.
- Linux ARM/ARM64/LoongArch64/Loongson: matching folders under `bin\linux`.
- macOS x86_64/arm64/universal: `bin\macos\<arch>\libD8SKF.dylib`.

## External resources

- Linux toolchains/OpenSSL: `<local SDK or checkout path>` and adjacent OpenSSL folders.
- macOS SDK: `<local SDK or checkout path>`.
- Release destination: `\\Desktop-ui6sarr\cd\新开发包\SKF开发包\头文件及库文件`.

Treat these as environment locations, not source-controlled dependencies. Verify existence before use.
