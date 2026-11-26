# SKF Demo 交付与验证



以下路径相对于 SKF 工程根目录。按用户要求选择对应 Demo，复用现有源码与发布物。



| 场景 | 源码 | 独立发布物 |

|---|---|---|

| C | 交付Demo/SKF_C_Crypto_Demo/skf_demo.c | 交付Demo/SKF_C_Standalone_Demo.zip |

| Python ctypes | 交付Demo/SKF_C_Crypto_Demo/skf_demo.py | 交付Demo/SKF_Python_Standalone_Demo.zip |

| Java JNI | 交付Demo/SKF_Java_Standalone_Demo/CryptoDemo.java | 交付Demo/SKF_Java_Standalone_Demo.zip |

| 浏览器 JavaScript | webhid-skf/index.html、webhid-skf/skf-webhid.js | SKF-WebHID-JS-完整示例.zip |

| Java PDF 签名 | java-skf/examples/rsa-pdf | java-skf/D8-RSA-SM2-PDF-Java-Demo.zip |



## C、Python 和 Java



- C 使用 SDK 头文件及配套导入库。Windows Python ctypes 采用 WinDLL、32 位 ULONG 和与进程位数匹配的 DLL，BLOCKCIPHERPARAM 按值传递。Java 17+ 需要与 JVM 位数匹配的 SKF 库及 JNI 桥。

- --list 枚举设备。--create 执行设备认证、创建应用、验证新用户 PIN、创建容器、生成 SM2 签名密钥及 D8 扩展加密密钥。复用双密钥容器时省略 --create。设备认证密钥与应用 PIN 分开输入。新建应用需要空闲槽位，测试应用默认保留。

- SM2 签名先计算 SM3(ZA || 消息)，验签使用同一用户 ID；SM2 加密导出加密公钥，私钥解密在容器内完成；SM4-CBC 示例使用随机密钥与 IV、无填充的单个完整块。两项解密均比较原文。

- Windows 真机记录：C 与 Python x64 已通过创建及三项密码运算；C、Python Win32 和 Java Windows x64/Win32 已用现有容器通过三项。Java Windows 创建尚未实测。

- Ubuntu WSL2 x86_64 的 Java 17 使用 java-skf/dist/linux/x86_64 的两个 SO，经临时适配 Skf.load 路径后，已通过新建应用、Container1、两对密钥和三项密码运算。独立 Java ZIP 是 Windows 版。其他 Linux 架构仅核对了 SKF 动态导出。WSL 先用 usbipd 确认 Attached，再用 lsusb 和 Java 枚举确认设备；Windows 已有容器若在 Linux 不可见，先只读枚举，使用获准的空闲测试槽。两个应用槽均占用时应换测试设备或由用户指定可删除的测试应用。



## 浏览器 WebHID



使用 localhost 或 HTTPS，由用户点击授权设备。核对固件 ID 26、序列号、随机数、SM2 签名验签和 SM4 ECB/CBC 往返。固件需要完整 257 字节 Feature Report，写 Report ID 2、读 ID 1；错误仅可见状态高字节。该示例覆盖指定功能，SM2 公钥加解密不在其中。

导入签名证书前比对容器签名公钥，导入后回读 DER。包内测试证书仅匹配原测试锁当时的密钥；换锁或重生成应重新签发，测试 CA 仅供测试。发布前运行 node --check，并分别记录静态检查、浏览器真机结果。



## Java PDF



从示例 README 运行 RsaPdfSignDemo 或 Sm2PdfSignDemo。使用匹配的签名证书和签名容器，证书应有 digitalSignature Key Usage。用 PDFBox 写入签名、Bouncy Castle 处理 CMS，重新读取最终 PDF 按 ByteRange 验证签名；在目标 WPS 版本检查签名覆盖的修订及篡改对照。WPS 的内容完整性与证书信任分别记录。

RSA-2048 已通过 Java/UKey 实签与最终 PDF 程序验签；客户证书及正式入口仍需验收。SM2 PDF 独立入口已编译，UKey PDF 实签和 WPS 尚未完成；普通 SM2 签名的真机通过不能替代 PDF 验收。


## Go 独立 Demo

交付Demo/SKF_Go_Standalone_Demo.zip 提供 Windows x64 Go 版本；三项密码运算已真机通过，创建流程待测。详情见 [Go 开发](go-sdk.md)。
