btmp 是 Linux 系统中的一个二进制日志文件，专门用于记录失败的登录尝试。

详细介绍：
 • 文件路径：通常位于 /var/log/btmp
 • 作用：记录所有失败的用户登录尝试，包括用户名、IP 地址、时间戳等信息。
 • 文件格式：二进制格式，不能直接用 cat、less 之类的工具查看。
 • 查看方式：
 1. 使用 lastb 命令：

lastb

这个命令类似于 last，但它读取的是 btmp 文件，而 last 读取的是 wtmp（成功登录日志）。

 2. 如果 lastb 命令不可用，可以用 utmpdump：

utmpdump /var/log/btmp

这会将二进制数据转换为可读的文本格式。

 3. 使用 strings（仅限快速查看可能包含的文本信息）：

strings /var/log/btmp



相关日志文件：
 • /var/log/wtmp：记录成功的登录和注销信息。
 • /var/log/utmp：记录当前登录的用户会话信息。

清理 btmp 文件：

如果 btmp 文件过大，可以定期清理：

> /var/log/btmp

或者使用 logrotate 进行自动管理。

⚠️ 注意事项：
 • btmp 文件非常重要，如果系统受到暴力破解攻击，该文件可以提供有价值的信息来分析攻击来源。
 • 如果 /var/log/btmp 丢失，可以手动创建：

touch /var/log/btmp
chmod 600 /var/log/btmp

这样系统才能继续记录失败的登录尝试。