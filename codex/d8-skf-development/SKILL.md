---
name: d8-skf-development
description: Build, package, diagnose, and test the D8 SKF UKey firmware-facing PC libraries, Java/JNI SDK, and management tools on Windows, Linux, and macOS. Use for this repository's SKF API, device enumeration, version-26 checks, certificates, PINs, cryptographic tests, or release delivery; do not use for unrelated generic USB or cryptography projects. Covers C/Python/Java demos, WebHID JS and Java PDF signing.
---

# D8 SKF development

Work from the repository root and preserve the existing command protocol and firmware architecture. Inspect current sources before changing them; do not infer behavior from an old binary or document when source is available.

## Route the task

- For repository paths, deliverables, and authoritative files, read [references/layout.md](references/layout.md).
- For Windows, Linux, macOS builds or release copying, read [references/build-and-release.md](references/build-and-release.md).
- For device, PIN, certificate, SM2/SM3/SM4/RSA/HMAC, or multi-device validation, read [references/test-workflows.md](references/test-workflows.md).
- For Java/JNI SDK builds, examples, or SM2 certificate encrypt/decrypt tests, read [references/java-sdk.md](references/java-sdk.md).


## Demo 示例

C、Python ctypes、Java JNI、浏览器 WebHID JS 和 Java PDF 签名的交付物、平台要求及真机验证记录见 [示例交付](references/demo-delivery.md)。

## Invariants

- SKF-capable devices must report ID version `26`; reject and disconnect other versions.
- `SKF_EnumDev` returns a MULTI_SZ list terminated by an extra NUL. Query the required byte count first, allocate that exact size, and parse within bounds.
- Use `D8SKF_GetDevSerialNumber` for the unique hardware serial number. Do not use `SKF_GetDevInfo` as a serial-number workaround.
- Keep `SKF_FILE_WRITE` at command `0xCE`. Firmware command routing must exclude `0xCE` from `HandleCertCmd` without restructuring unrelated routing.
- Never overwrite or delete a production container, key, certificate, PIN, or device-authentication key merely to make a test pass. Destructive tests require an explicitly designated disposable device/container.
- Private keys generated inside the UKey are non-exportable. A CA certificate is usable only when its public key matches the corresponding device private key.
- Signing and encryption keys/certificates are distinct slots in one SKF container even if a test configuration chooses the same key pair.
- Linux release SOs must embed OpenSSL and libusb as configured, and must not require a newer glibc than the requested target. Do not attempt to upgrade a target system's glibc.

## Completion standard

Build only the requested configurations, check exported symbols and binary architecture, run non-destructive tests proportional to the change, and compare hashes after copying release files. Report exact output paths, tested scope, skipped hardware tests, and any remaining warnings.

Use `scripts/audit-release.ps1` to inventory and hash the standard release outputs before delivery.
