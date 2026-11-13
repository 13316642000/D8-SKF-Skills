# Java/JNI SDK

The Java SDK is `java-skf/` under the repository root. The authoritative Java API is `src/main/java/com/d8/skf/Skf.java`; JNI implementation and ABI declarations are `native/skf_jni.cpp` and `native/skf_abi.h`. Check the current `SKF/D8Skf.h` before changing wrappers. The JAR calls the existing per-platform SKF core library through a JNI bridge; do not describe it as a Java reimplementation of the device protocol.

Build with `java-skf/build-java.ps1` (Java 17 bytecode), `build-windows.ps1`, `build-linux.sh` under WSL, and `build-macos.sh` under WSL. Run `java-skf/package.ps1` to create `java-skf/D8-SKF-Java-开发包.zip`. Its README documents the platform paths and supported scope. Rebuild the affected binaries before packaging; do not copy stale JNI libraries.

For the complete SM2 encryption example, use `com.d8.skf.Sm2EncryptDecryptDemo`. The matching self-signed test certificate and plaintext private key are `java-skf/tests/certs/sm2-encryption-test-cert.der` and `sm2-encryption-test-key.pem`. The example checks that the certificate public key matches the key, imports an encrypted private-key envelope and certificate into a *free temporary* container, encrypts through the public key, decrypts inside the UKey, and deletes that container. It requires one version-26 disposable test device with the development auth key and user PIN; never run it on a production device or overwrite an occupied container. The test private key is intentionally public in the package and must never be used for production.

Example on Linux x64 from the `java-skf` directory, after building and attaching the test UKey:

```bash
java -cp build/d8-skf-java.jar com.d8.skf.Sm2EncryptDecryptDemo \
  "$(pwd)/build/linux/x86_64/libD8SKFJava.so" \
  /mnt/e/UKeyEx/MFCApplication1/bin/linux/x86_64-glibc231/libD8_x64.so \
  tests/certs/sm2-encryption-test-key.pem tests/certs/sm2-encryption-test-cert.der
```

Check exit code, matching plaintext, and deletion of the temporary container. On non-x64 platforms distinguish a successful build from unrun hardware tests. Current Linux/macOS core transport still returns `-25` for the two legacy file-import extensions; Java wrapper coverage does not imply those lower-level extensions work there.
