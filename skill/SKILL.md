---
name: dl
slug: dl
version: 1.0.0
description: "国内网络环境 GitHub 下载加速工具。通过 SSH 端口 443 克隆仓库，通过镜像代理下载 Release 文件，绕过 GFW 限制。适用场景：(1) 克隆 GitHub 仓库失败或极慢；(2) 下载 Release 文件超时；(3) 使用国内云服务器（腾讯云、阿里云等）需要访问 GitHub。"
metadata: {"clawdbot":{"emoji":"⬇️","requires":{"bins":["git","curl","ssh"]},"os":["linux","darwin"]}}
---

## 适用场景

当任务涉及从 GitHub 下载内容，且用户处于 GitHub 访问受限或缓慢的网络环境时使用（常见于国内云服务器）。本工具提供：

1. **仓库克隆加速** — SSH 端口 443 隧道，绕过 GFW 深度包检测
2. **Release 文件下载** — 多镜像源代理轮询，自动故障切换
3. **短格式语法** — `github:user/repo/tag/file` 简写下载地址

## 安装

### 一键安装

```bash
curl -fsSL https://raw.githubusercontent.com/Aquarius-mu/SDL-HUB/main/install.sh | bash
```

### 手动安装

```bash
git clone https://github.com/Aquarius-mu/SDL-HUB.git
cd SDL-HUB
cp dl ~/bin/dl
chmod +x ~/bin/dl
export PATH="$HOME/bin:$PATH"
```

安装后 `dl` 脚本位于 `~/bin/dl`，确保 `~/bin` 在 PATH 中：

```bash
export PATH="$HOME/bin:$PATH"
```

## 命令参考

### 克隆仓库

```bash
dl clone <github-url> [目标目录]
```

支持 HTTPS 和 SSH 地址，自动转换为 SSH 端口 443 连接。

```bash
dl clone https://github.com/user/repo.git
dl clone git@github.com:user/repo.git
dl clone https://github.com/user/repo.git /path/to/dir
```

**克隆策略（按优先级）：**
1. SSH 端口 443（最可靠，绕过 GFW）
2. HTTPS 直连（15 秒超时）
3. 镜像代理（ghproxy.cn、ghps.cc、gh.xmly.dev）

### 下载 Release 文件

```bash
# 完整 URL
dl https://github.com/user/repo/releases/download/v1.0/file.tar.gz

# 短格式
dl github:user/repo/v1.0/file.tar.gz

# 指定输出目录
dl --out /tmp https://github.com/.../file.zip

# 批量下载
dl url1 url2 url3
```

**下载策略：** 自动检测 GitHub URL，优先使用镜像代理，失败后直连。

### 镜像源管理

```bash
dl --test    # 测试镜像源速度
dl --list    # 列出可用镜像源
```

### 下载模式

```bash
dl --direct <url>         # 强制直连（跳过镜像）
dl --proxy <url>          # 强制仅用镜像
dl --mirror <N> <url>     # 使用第 N 个镜像源
```

## 前置条件

- `git`、`curl`、`ssh` 已安装
- SSH 密钥已配置并添加到 GitHub

### 配置 SSH 端口 443

编辑 `~/.ssh/config`：

```
Host github.com
    HostName ssh.github.com
    Port 443
    User git
    IdentityFile ~/.ssh/id_ed25519
    StrictHostKeyChecking no
```

### 验证连接

```bash
ssh -T git@github.com
# 成功: Hi username! You've successfully authenticated...
```

## 常见问题

| 问题 | 解决方案 |
|------|----------|
| `dl: command not found` | 运行 `export PATH="$HOME/bin:$PATH"` 或重新打开终端 |
| SSH 克隆失败 | 运行 `ssh -T git@github.com` 检查密钥是否已添加到 GitHub |
| 所有镜像都失败 | 运行 `dl --test` 检查镜像可用性，网络环境可能已变化 |
| 下载超时 | 尝试 `dl --direct <url>` 跳过镜像直连 |
| 权限被拒绝 | 运行 `chmod +x ~/bin/dl` 添加执行权限 |
| 密钥未配置 | 运行 `ssh-keygen -t ed25519` 生成密钥，将公钥添加到 GitHub Settings |
| SSH 端口 22 不通 | 确认 `~/.ssh/config` 中配置了 `Port 443` |

## 镜像源

| 镜像 | 用途 | 状态 |
|------|------|------|
| ghproxy.cn | Release 文件下载 | 活跃 |
| ghps.cc | Release 文件下载 | 活跃 |
| gh.xmly.dev | Release 文件下载 | 活跃 |

运行 `dl --test` 查看实时测速结果。

## 技术原理

### 为什么 SSH 端口 443 能绕过限制？

GFW 对 GitHub 的 SSH 默认端口 22 进行了深度包检测和干扰，但端口 443（HTTPS 标准端口）的流量通常不会被严格审查。GitHub 的 `ssh.github.com` 在端口 443 提供 SSH 服务，使得通过该端口的 git 操作可以正常进行。

### 镜像代理原理

GitHub 镜像代理服务接收形如 `https://mirror/https://github.com/path` 的请求，代理服务器从 GitHub 获取资源后返回给用户。这些代理服务器通常部署在海外或有专线接入，绕过了国内到 GitHub 的网络瓶颈。
