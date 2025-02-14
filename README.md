#!/bin/bash
# firewall-setup.sh - 防火墙规则脚本

# 清空所有规则
iptables -F

# 允许 SSH 访问
iptables -A INPUT -p tcp --dport 22 -j ACCEPT

# 允许 HTTP 和 HTTPS 访问
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -p tcp --dport 443 -j ACCEPT

# 拒绝所有其他入站连接
iptables -P INPUT DROP

# 保存规则
service iptables save  # 适用于 CentOS 6
iptables-save > /etc/sysconfig/iptables  # 手动保存规则

echo "Firewall rules applied successfully!"

然后给脚本赋予执行权限：

chmod +x firewall-setup.sh

执行：

./firewall-setup.sh

优点
 • 易读、易修改
 • 可随时执行
 • 适用于 iptables、firewalld、ufw 等命令

缺点
 • 需要手动执行或添加到 cron 定时任务

2. iptables 规则保存文件

适用于： iptables 规则长期存储、自动加载

如果你使用 iptables，可以用 iptables-save 和 iptables-restore 来管理规则。

保存当前规则

iptables-save > /etc/sysconfig/iptables  # CentOS/RHEL
iptables-save > /etc/iptables/rules.v4  # Ubuntu/Debian

恢复规则

iptables-restore < /etc/sysconfig/iptables  # CentOS/RHEL
iptables-restore < /etc/iptables/rules.v4  # Ubuntu/Debian

优点
 • 规则直接存储，可随系统启动自动恢复
 • 适合长期维护防火墙规则

缺点
 • 规则以文本格式存储，但不易手动编辑
 • 仅适用于 iptables

3. firewalld 配置文件

适用于： firewalld 规则存储、自动加载

firewalld 会将规则保存在 /etc/firewalld/zones/ 目录下，例如：

cat /etc/firewalld/zones/public.xml

你也可以导出规则：

firewall-cmd --runtime-to-permanent

如果要手动编辑规则：

vi /etc/firewalld/zones/public.xml

然后重启防火墙：

firewall-cmd --reload

优点
 • firewalld 自动管理，无需手动执行
 • 规则 XML 文件可直接编辑

缺点
 • 需要熟悉 firewalld 配置格式
 • 仅适用于 firewalld

4. ansible / puppet / chef 自动化管理

适用于： 大规模服务器运维、自动部署

如果你要管理多个服务器的防火墙规则，可以使用 Ansible 来编写 YAML 配置文件。例如：

Ansible Playbook

- name: Configure firewall
  hosts: all
  become: yes
  tasks:
    - name: Allow SSH
      firewalld:
        service: ssh
        permanent: yes
        state: enabled

    - name: Allow HTTP and HTTPS
      firewalld:
        service: http
        permanent: yes
        state: enabled

    - name: Reload firewalld
      command: firewall-cmd --reload

然后执行：

ansible-playbook firewall.yml

优点
 • 适用于大规模服务器管理
 • 易于回滚和版本管理

缺点
 • 需要额外学习 Ansible
 • 适合高级运维

5. 版本控制（Git / SVN）

适用于： 团队管理、变更记录

你可以将防火墙规则（如 firewall-setup.sh 或 iptables 规则）存入 Git 仓库，以便跟踪历史变化：

git init
git add firewall-setup.sh
git commit -m "Initial firewall rules"

在修改规则后：

git commit -am "Updated firewall rules for new services"

优点