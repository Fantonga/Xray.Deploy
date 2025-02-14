在 CentOS 中，防火墙主要使用 firewalld（默认）或 iptables（较旧版本）。以下是完整的 CentOS 防火墙命令大全，包含 firewalld 和 iptables 两种方式的常见用法。

1. Firewalld（CentOS 7+ 默认防火墙）

1.1. 防火墙基本管理

systemctl start firewalld      # 启动防火墙
systemctl stop firewalld       # 停止防火墙
systemctl restart firewalld    # 重启防火墙
systemctl enable firewalld     # 开机自启防火墙
systemctl disable firewalld    # 禁止防火墙开机自启
systemctl status firewalld     # 查看防火墙状态
firewall-cmd --state          # 检查防火墙是否运行

1.2. 查看防火墙规则

firewall-cmd --list-all          # 查看当前区域所有防火墙规则
firewall-cmd --list-services      # 查看已开放的服务
firewall-cmd --list-ports         # 查看已开放的端口
firewall-cmd --get-zones          # 查看所有区域
firewall-cmd --get-active-zones   # 查看当前使用的区域
firewall-cmd --query-port=80/tcp  # 查询端口 80 是否开放
firewall-cmd --query-service=http # 查询 HTTP 服务是否允许

1.3. 开放端口

firewall-cmd --zone=public --add-port=80/tcp --permanent   # 开放 80 端口（HTTP）
firewall-cmd --zone=public --add-port=443/tcp --permanent  # 开放 443 端口（HTTPS）
firewall-cmd --zone=public --add-port=3306/tcp --permanent # 开放 3306 端口（MySQL）
firewall-cmd --zone=public --add-port=22/tcp --permanent   # 开放 SSH 端口
firewall-cmd --reload   # 重新加载防火墙配置使生效

1.4. 关闭端口

firewall-cmd --zone=public --remove-port=80/tcp --permanent  # 关闭 80 端口
firewall-cmd --zone=public --remove-port=443/tcp --permanent # 关闭 443 端口
firewall-cmd --reload  # 重新加载防火墙规则

1.5. 允许/禁止特定服务

firewall-cmd --zone=public --add-service=http --permanent   # 允许 HTTP
firewall-cmd --zone=public --add-service=https --permanent  # 允许 HTTPS
firewall-cmd --zone=public --remove-service=http --permanent  # 禁止 HTTP
firewall-cmd --reload  # 重新加载防火墙

1.6. 允许/拒绝 IP 访问

firewall-cmd --zone=public --add-rich-rule='rule family="ipv4" source address="192.168.1.100" accept' --permanent
firewall-cmd --zone=public --add-rich-rule='rule family="ipv4" source address="192.168.1.200" drop' --permanent
firewall-cmd --reload

 • 允许 192.168.1.100 访问服务器
 • 拒绝 192.168.1.200 访问服务器

1.7. 开启端口转发

firewall-cmd --zone=public --add-forward-port=port=8080:proto=tcp:toport=80 --permanent
firewall-cmd --reload

 • 这条规则会把 8080 端口流量转发到 80 端口。

1.8. 临时关闭防火墙（仅限测试，不建议长期关闭）

systemctl stop firewalld   # 停止防火墙
systemctl disable firewalld # 禁止防火墙开机启动

2. iptables（适用于 CentOS 6 及部分 CentOS 7）

2.1. 启动 / 停止 / 重启防火墙

service iptables start    # 启动 iptables
service iptables stop     # 停止 iptables
service iptables restart  # 重启 iptables
chkconfig iptables on     # 设置开机启动
chkconfig iptables off    # 禁止开机启动

2.2. 查看防火墙规则

iptables -L -n -v        # 列出所有规则
iptables -S              # 查看详细规则
iptables -L INPUT -n -v  # 查看 INPUT 规则

2.3. 允许特定端口

iptables -A INPUT -p tcp --dport 80 -j ACCEPT   # 开放 80 端口
iptables -A INPUT -p tcp --dport 443 -j ACCEPT  # 开放 443 端口
iptables -A INPUT -p tcp --dport 22 -j ACCEPT   # 开放 SSH
iptables -A INPUT -p tcp --dport 3306 -j ACCEPT # 开放 MySQL
service iptables save   # 保存规则
service iptables restart # 重启防火墙

2.4. 拒绝 IP 访问

iptables -A INPUT -s 192.168.1.200 -j DROP
iptables -A INPUT -s 192.168.1.0/24 -j DROP  # 禁止 192.168.1.0/24 网段访问
service iptables save
service iptables restart

2.5. 允许指定 IP 访问

iptables -A INPUT -s 192.168.1.100 -j ACCEPT  # 允许 192.168.1.100 访问
iptables -A INPUT -s 10.0.0.0/8 -j ACCEPT    # 允许 10.0.0.0/8 网段访问
service iptables save
service iptables restart

2.6. 删除防火墙规则

iptables -D INPUT -p tcp --dport 80 -j ACCEPT  # 关闭 80 端口
iptables -D INPUT -s 192.168.1.100 -j ACCEPT   # 移除允许的 IP
service iptables save
service iptables restart

2.7. 彻底关闭 iptables（不推荐）

service iptables stop
chkconfig iptables off

总结

功能 firewalld 命令 iptables 命令
启动防火墙 systemctl start firewalld service iptables start
停止防火墙 systemctl stop firewalld service iptables stop
开放端口 firewall-cmd --add-port=80/tcp --permanent iptables -A INPUT -p tcp --dport 80 -j ACCEPT
关闭端口 firewall-cmd --remove-port=80/tcp --permanent iptables -D INPUT -p tcp --dport 80 -j ACCEPT
允许 IP firewall-cmd --add-rich-rule='rule family="ipv4" source address="192.168.1.100" accept' --permanent iptables -A INPUT -s 192.168.1.100 -j ACCEPT
拒绝 IP firewall-cmd --add-rich-rule='rule family="ipv4" source address="192.168.1.200" drop' --permanent iptables -A INPUT -s 192.168.