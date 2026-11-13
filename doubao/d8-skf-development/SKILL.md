---
name: d8-skf-development
description: 用于 D8 SKF UKey 工程的源码修改、多平台库及 Java/JNI SDK 编译、发布校验和设备自动化测试。涉及 SKF 接口、版本 26、多设备枚举、硬件序列号、PIN、容器、证书、SM2/SM3/SM4/RSA/HMAC 或 Windows/Linux/macOS 库时使用；不适用于无关的通用 USB 或密码学项目。 也用于 C、Python、Java Demo、WebHID JS 和 Java PDF 签名。
---

# D8 SKF 开发与测试

在工程根目录工作，修改前先检查当前源码。保持既有固件命令协议和工程架构，不根据旧二进制或旧文档猜测当前实现。

## 按任务读取资料

- 查找源码、输出文件和外部工具链时，读取 [references/工程目录.md](references/工程目录.md)。
- 编译或发布 Windows、Linux、macOS 库时，读取 [references/编译发布.md](references/编译发布.md)。
- 测试设备、PIN、证书和密码算法时，读取 [references/测试流程.md](references/测试流程.md)。
- 编译 Java/JNI 开发包、运行 Java 示例或测试 SM2 证书加解密时，读取 [references/Java开发包.md](references/Java开发包.md)。

## 必须保持的规则

- SKF 设备 ID 版本必须为 `26`；其他版本连接后应提示并断开。
- `SKF_EnumDev` 返回以双 NUL 结束的 MULTI_SZ。先查询长度，再按长度分配缓冲区，并在边界内解析全部设备。
- 获取唯一硬件序列号使用 `D8SKF_GetDevSerialNumber`，不能用可能崩溃的 `SKF_GetDevInfo` 代替。
- `SKF_FILE_WRITE` 命令保持为 `0xCE`；固件路由只需将 `0xCE` 排除在 `HandleCertCmd` 之外，不随意调整其他命令或架构。
- 不得为了测试通过而覆盖或删除生产容器、密钥、证书、PIN 或设备认证密钥。破坏性测试只能使用用户明确指定的测试设备和临时容器。
- 锁内生成的私钥不可导出；导入 CA 证书前必须确认其公钥与对应私钥匹配。
- 一个 SKF 容器可分别保存签名和加密密钥/证书，两者是独立槽位。
- Linux SO 按工程配置静态包含 OpenSSL 和 libusb，GLIBC 要求不得超过目标系统；禁止建议升级目标机 GLIBC。

## 完成标准

只编译用户要求的配置，检查二进制架构、导出符号和动态依赖，执行与改动风险相符的非破坏性测试。发布复制后逐文件核对 SHA-256，并报告准确路径、已测范围、未执行的硬件测试及剩余警告。

可运行 `scripts/audit-release.ps1` 盘点标准发布产物并计算哈希。

## Demo 示例

C、Python ctypes、Java JNI、浏览器 WebHID JS 和 Java PDF 签名的交付物、平台要求及真机验证记录见 [示例交付](references/示例交付.md)。
