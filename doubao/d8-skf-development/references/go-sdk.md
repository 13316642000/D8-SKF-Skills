# Go 直接调用 SKF

## 源码与交付物

工程相对路径为 交付Demo/SKF_Go_Standalone_Demo/，独立包为 交付Demo/SKF_Go_Standalone_Demo.zip。源码 main.go，构建脚本 build.cmd，运行库 x64/D8SKF.dll。目标为 Windows x64、Go 1.22+，使用标准库 syscall，无 cgo 和第三方 Go 依赖。

## 入口

在解压目录执行 skf_demo.exe --list。新建流程执行 skf_demo.exe --create "设备名" GoDemo Container1；复用容器执行 skf_demo.exe "设备名" "应用名" "容器名"。默认从 EXE 目录的 x64/D8SKF.dll 加载，可用 --dll 指定路径。应用和容器名称建议使用 ASCII。

新建流程依次核对 ID 版本 26，完成 SM4-ECB 设备挑战认证、新建应用、验证用户 PIN、新建容器并生成两对 SM2 密钥。设备认证密钥为 16 个可打印 ASCII 字符，与管理员和用户 PIN 分开输入。新建应用需空闲槽位，持久对象保留。

SM2 签名摘要含 ZA，使用约定的 SM2 ID；加密使用加密公钥，解密调用容器内私钥。SM4-CBC 使用随机临时密钥、随机 IV 和无填充的 16 字节消息。两项解密均比较恢复后的明文。

## Windows x64 ABI

ULONG 固定为 uint32，句柄为 uintptr。SKF 的非小型按值结构 BLOCKCIPHERPARAM 在 Windows x64 ABI 下间接传递，此实现以结构地址调用。该调用方式只用于目标 Windows x64。原生调用期间必须保持 Go 分配对象存活，main.go 的 nativeRoots 为本短生命周期 Demo 保留地址指向对象。移植或重构时保留指针存活与堆分配条件。关闭子句柄后再关闭应用与设备。

## 构建与验证记录

执行 go build -buildvcs=false -o skf_demo.exe . 和 go vet -buildvcs=false .。

2026-11-26 Windows x64 真机日志确认，在现有测试应用 WslJava153028 的 Container1 上三项均通过，退出码 0：
- SM2 sign/verify OK
- SM4 CBC encrypt/decrypt OK
- SM2 encrypt/decrypt OK

Go --create 的设备认证、新建应用和生成密钥尚未真机验证。记录中容器名称仅用于本次测试，后续先枚举并核对设备现状。网页 Go 后台属于无锁的软件验签服务，入口见 web-development.md。
