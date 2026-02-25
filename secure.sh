#!/bin/bash

# =========================================================
# 脚本名称: VLX@Tech VPS 安全与流量管理一键脚本 (最终修复版)
# 适用环境: Debian 11/12+, Ubuntu 20.04+ (Azure 优化)
# 作者: vlongx (tipvps.com)
# =========================================================

# --- 自定义配置 ---
NEW_PORT=28475  # 建议修改为 10000-65535 之间的随机端口

echo "=== 开始 VLX@Tech 安全加固流程 ==="

# 1. 基础工具安装
echo "[1/4] 安装必要组件..."
apt-get update && apt-get install -y vnstat fail2ban curl bc

# 2. 解决日志占用过大问题 (针对 journal 和 btmp)
echo "[2/4] 正在清理并压缩系统日志..."
# 限制 journal 日志上限为 50MB，防止长期占用几百 MB 空间
sed -i 's/^#SystemMaxUse=/SystemMaxUse=50M/' /etc/systemd/journald.conf
systemctl restart systemd-journald
journalctl --vacuum-size=50M
# 清空已记录的爆破失败日志 (btmp)
cat /dev/null > /var/log/btmp

# 3. SSH 安全加固与 Fail2Ban 修复
echo "[3/4] 正在配置 SSH 与 Fail2Ban (systemd 兼容版)..."
# 修改 SSH 端口
sed -i "s/^#Port 22/Port $NEW_PORT/" /etc/ssh/sshd_config
sed -i "s/^Port 22/Port $NEW_PORT/" /etc/ssh/sshd_config
systemctl restart ssh

# 写入兼容 Debian/Azure 的 Fail2Ban 配置
cat <<EOF > /etc/fail2ban/jail.local
[sshd]
enabled = true
port = $NEW_PORT
filter = sshd
# 关键修复：使用 systemd 后端以解决找不到 auth.log 的问题
backend = systemd
maxretry = 5
findtime = 600
bantime = 3600
EOF

systemctl restart fail2ban

# 4. 流量监控初始化 (针对监控探针流量)
echo "[4/4] 正在初始化 vnStat 流量监控..."
systemctl enable --now vnstat
# 确保数据目录权限正确
chown -R vnstat:vnstat /var/lib/vnstat

echo "================================================="
echo "✅ 加固完成！"
echo "1. SSH 端口已改为: $NEW_PORT (请务必记牢)"
echo "2. 日志上限已设为 50MB，旧日志已清理。"
echo "3. Fail2Ban 已启动，正在通过 systemd 监控暴力破解。"
echo "4. 输入 'vnstat' 即可查看流量统计数据。"
echo "================================================="
