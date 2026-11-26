# DeepSeek harness 接入

本包采用文件型技能结构。将 d8-skf-development 放入 harness 的技能目录，并让 harness 在 SKF 开发请求匹配时读取 SKILL.md，再按任务读取 references/。具体注册路径取决于当前 harness 配置。

若 harness 没有自动技能发现，将以下提示加入该工程的代理指令。

“处理 D8 SKF UKey、C/Python/Java Demo、WebHID/Vue 网页、后台软件验签或 PDF 签名任务时，先读取本技能目录的 SKILL.md，按其链接读取相关参考。工程根目录由当前工作区解析，工具命令使用当前 harness 提供的执行能力。”

脚本为 PowerShell，Linux 可使用 pwsh 执行或按脚本内容完成相同检查。设备认证密钥和 PIN 由用户在本机输入。
