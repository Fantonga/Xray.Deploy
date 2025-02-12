# 基础连接优化
net.core.somaxconn = 65535      # 监听队列最大值
net.core.netdev_max_backlog = 65535  # 网卡接收队列长度
net.ipv4.tcp_max_syn_backlog = 65535 # 半连接队列大小

# TIME-WAIT 优化（适用于主动关闭连接的场景）
net.ipv4.tcp_fin_timeout = 30        # 缩短 FIN 超时
net.ipv4.tcp_tw_reuse = 1            # 允许复用 TIME-WAIT
net.ipv4.tcp_max_tw_buckets = 2000000 # 最大 TIME-WAIT 数量

# 端口范围扩展
net.ipv4.ip_local_port_range = 1024 65535

# 内存和缓冲区调整
net.ipv4.tcp_rmem = 4096 87380 16777216  # 接收窗口
net.ipv4.tcp_wmem = 4096 65536 16777216  # 发送窗口
net.core.rmem_max = 16777216
net.core.wmem_max = 16777216
net.ipv4.tcp_mem = 8388608 12582912 16777216 # 根据内存调整

# 拥塞控制算法（推荐 BBR）
net.ipv4.tcp_congestion_control = bbr
net.core.default_qdisc = fq

# 其他关键参数
net.ipv4.tcp_syncookies = 0          # 高并发时关闭 syncookies
net.ipv4.tcp_slow_start_after_idle = 0 # 禁用空闲后慢启动
net.ipv4.tcp_notsent_lowat = 16384   # 减少发送缓冲区阻塞