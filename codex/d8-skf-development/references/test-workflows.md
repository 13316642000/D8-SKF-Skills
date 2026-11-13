# Test workflows

## Safe discovery

1. Call `SKF_EnumDev(TRUE, NULL, &size)`.
2. Allocate `size` bytes and call it again.
3. Parse every NUL-terminated device name until the final empty string.
4. Connect each name independently and require ID version 26.
5. Call `D8SKF_GetDevSerialNumber` first with a null buffer to get size, then with a bounded buffer.

Three identical VID/PID devices must yield three paths and independently retrievable serial numbers.

## Non-destructive order

Connect → authenticate if required → open application → verify the required PIN → open an existing container → inspect keys/certificates → run read-only or round-trip tests.

Validate SM3, SM4 ECB/CBC, SM2 sign/verify and encrypt/decrypt, and available RSA/HMAC/key-agreement functions, including multipart variants. Compare with an independent software implementation when practical.

## Certificates

- Signing: device generates signing key → CSR uses that public key → CA signs → verify key match → import signing certificate.
- Encryption: generate the encryption key in-device and provision its matching certificate, or import an approved encrypted private-key package with `SKF_ImportECCKeyPair`.
- Test exported signing and encryption certificates separately against their respective public keys.

Always report the failing API, exact hexadecimal SKF code, and last successful step. Do not assign a single cause to generic code `0x0A000001` without evidence. If hardware is unavailable, run loading, symbol, dependency, and software-vector checks and mark device tests as not run.
