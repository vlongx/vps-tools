# 🚀 VLX@Tech VPS 安全与流量管理工具箱

此项目由 [tipvps.com](https://tipvps.com) 维护，旨在为自建 VPS 用户提供一键式的安全加固与流量监控方案，特别优化了 Azure 和 Debian 环境。

## 🌟 核心功能
* **🛡️ 安全加固**：自动修改 SSH 端口，并配置 Fail2Ban 拦截爆破攻击。
* **🧹 空间优化**：深度清理 `journal` 与 `btmp` 日志，强制限制上限为 50MB。
* **📊 流量监控**：通过 `vnstat` 精准监控包括探针（如哪吒探针）在内的实时流量。
* **☁️ 极致兼容**：完美支持无 `auth.log` 的现代 Debian/Ubuntu 镜像。

## 🚀 一键执行
在 root 用户下执行以下命令：
```bash
curl -sSL [https://raw.githubusercontent.com/vlongx/vps-tools/main/secure.sh](https://raw.githubusercontent.com/vlongx/vps-tools/main/secure.sh) | bash
