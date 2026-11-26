# Java/JNI 开发包

工程位于根目录 `java-skf/`。Java API 以 `src/main/java/com/d8/skf/Skf.java` 为准；JNI 实现在 `native/skf_jni.cpp`，ABI 声明在 `native/skf_abi.h`。修改封装时核对当前 `SKF/D8Skf.h`。JAR 经 JNI 调用各平台已有的 SKF 核心库，不是用 Java 重写设备协议。

使用 `java-skf/build-java.ps1` 生成兼容 Java 17 的 JAR；Windows JNI 用 `build-windows.ps1`，Linux 和 macOS JNI 分别在 WSL 中运行 `build-linux.sh`、`build-macos.sh`。完成对应平台构建后运行 `java-skf/package.ps1`，得到 `java-skf/D8-SKF-Java-开发包.zip`。详细路径和调用方式见同目录 README。不能把旧 JNI 二进制当作本次构建产物。

完整 SM2 加解密例子为 `com.d8.skf.Sm2EncryptDecryptDemo`。配套自签发测试加密证书及明文私钥分别在 `java-skf/tests/certs/sm2-encryption-test-cert.der`、`sm2-encryption-test-key.pem`。例子核对证书公钥与私钥，在**空闲临时容器**导入加密私钥信封与证书，用公钥加密、锁内私钥解密，并删除该容器。只可在使用开发认证密钥、开发用户 PIN 的版本 26 可随意操作测试锁上运行；不得覆盖已有容器。随包提供的测试私钥已公开，绝不可用于生产。

Linux x64 在 `java-skf` 目录、设备已接入时执行：

```bash
java -cp build/d8-skf-java.jar com.d8.skf.Sm2EncryptDecryptDemo \
  "$(pwd)/build/linux/x86_64/libD8SKFJava.so" \
  /mnt/e/UKeyEx/MFCApplication1/bin/linux/x86_64-glibc231/libD8_x64.so \
  tests/certs/sm2-encryption-test-key.pem tests/certs/sm2-encryption-test-cert.der
```

核对退出码、解密后明文一致及临时容器已删除。其他架构编译成功不等于实机测试通过。Linux/macOS 核心传输层目前对两个旧式文件导入扩展仍返回 `-25`，Java 封装覆盖不能代替底层功能实现。
