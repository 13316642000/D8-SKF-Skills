# 网页 WebHID、Vue 与后台软件验签

以工程 webhid-skf/README.md 和对应源码为当前接口依据。原生页面为 index.html，Vue 3 + Vite 在 vue/，两者复用 skf-webhid.js 的设备命令。

## 入口和运行环境

- 启动示例.cmd 提供 localhost:8765 静态页面。
- 启动Vue示例.cmd 提供 localhost:8771，启动时可选择 Java、Python、C#、Go 或 PHP 后台，复用已监听的服务或等待新服务就绪。vue/ 中 npm run build 构建前端。Node 版本参照 vue/package.json 和 README。
- WebHID 需要支持它的浏览器、安全上下文及用户点击授权。设备 VID:PID 为 3689:8762，连接后检查 ID 版本 26、硬件序列号和容器。
- 完整 257 字节 Feature Report，写 ID 2、读 ID 1。当前固件经 WebHID 仅可见错误状态高字节，日志保留命令及实际响应。

## 网页签名与后台验签

先核对签名证书公钥与容器签名公钥，导入后回读 DER。新生成密钥后应重新签发匹配证书。包内证书仅适用于签发时的测试密钥。

网页在设备内计算含 ZA 的 SM3 摘要并调用私钥签名，设备验签与后台软件验签各有结果。后台接收同一原文、相同 SM2 ID、签名及 DER 证书，只用证书公钥验签。请求字段以源码为准，包括 messageBase64、identity、signature、certificate。检查 r||s 到 ASN.1 DER 的转换、Base64 和 UTF-8 编码。

| 后台 | 端口 | 源码及依赖 |
|---|---|---|
| Java | 8766 | java/VerifyServer.java，JDK 21、Bouncy Castle |
| Python | 8767 | python/verify_server.py，标准库 SM3 和 SM2 曲线实现 |
| C# | 8768 | csharp/VerifyServer.csproj，.NET 9、BouncyCastle.Cryptography |
| Go | 8769 | go/main.go，emmansun/gmsm |
| PHP | 8770 | php/router.php，PHP 8.1+、OpenSSL 3+，可用 SKF_OPENSSL 指定路径 |

Vue 代理路径依次为 /api/verify、/api/python-verify、/api/csharp-verify、/api/go-verify、/api/php-verify。检查代理目标、实际请求 URL、HTTP 状态和响应正文，避免把后台启动或网络失败归为签名错误。使用源码中的启动脚本及 README 参数。

## 验证与交付

运行 node --check 检查设备 JS，Vue 修改后运行 npm run build。浏览器真机检查版本、连接、容器与证书匹配、设备签名验签、五种后台的验签结果，以及原文/签名/ID 篡改后拒绝。SM4 检查 ECB、CBC，UTF-8 原文按 PKCS#7 填充、设备加解密及明文比较。记录每种后台实际测试范围，源码检查和运行通过分别报告。

发布网页 Demo 包时带前端、启动脚本、后台源码及必要运行依赖，按 README 核对证书。技能包只提供开发与测试指引，Demo 运行库按任务另行打包。开发服务监听本机，公网部署按目标环境配置 HTTPS 与访问控制。
