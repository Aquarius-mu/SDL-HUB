# SDL-HUB

**SDL-HUB** (Smart Download Hub) 是一款专为国内网络环境设计的 GitHub 下载加速工具。通过 SSH 端口 443 隧道和多镜像源轮询，解决在国内服务器上访问 GitHub 缓慢或无法连接的问题。

## 功能特性

- **仓库克隆加速** — SSH 端口 443 隧道，绕过 GFW 深度包检测
- **Release 文件下载** — 多镜像源自动轮询，失败自动切换
- **短格式语法** — `github:user/repo/tag/file` 一行搞定下载
- **批量下载** — 支持同时传入多个 URL
- **镜像源测速** — 一键检测当前可用镜像

## 快速安装

### 一键安装

```bash
curl -fsSL https://raw.githubusercontent.com/Aquarius-mu/SDL-HUB/main/install.sh | bash
```

### 手动安装

```bash
git clone https://github.com/Aquarius-mu/SDL-HUB.git
cd SDL-HUB
chmod +x dl
mkdir -p ~/bin
cp dl ~/bin/dl
echo 'export PATH="$HOME/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

## 使用方法

### 克隆仓库

```bash
# HTTPS 地址
dl clone https://github.com/user/repo.git

# SSH 地址
dl clone git@github.com:user/repo.git

# 指定目标目录
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
dl --out /tmp https://github.com/user/repo/releases/download/v1.0/file.zip

# 批量下载
dl url1 url2 url3
```

### 镜像源管理

```bash
dl --test    # 测试镜像源速度
dl --list    # 列出可用镜像源
```

### 下载模式

```bash
dl --direct <url>         # 强制直连下载（跳过镜像）
dl --proxy <url>          # 强制仅用镜像下载
dl --mirror <N> <url>     # 使用第 N 个镜像源
```

## 前置条件

- `git`、`curl`、`ssh` 已安装
- SSH 密钥已配置并添加到 GitHub

### 配置 SSH 密钥

```bash
# 1. 生成密钥
ssh-keygen -t ed25519 -C "your-email@example.com"

# 2. 复制公钥
cat ~/.ssh/id_ed25519.pub

# 3. 添加到 GitHub: https://github.com/settings/keys
```

### 配置 SSH 端口 443

编辑 `~/.ssh/config`，添加以下内容：

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
# 成功输出: Hi username! You've successfully authenticated...
```

## 常见问题

| 问题 | 解决方案 |
|------|----------|
| `dl: command not found` | 运行 `export PATH="$HOME/bin:$PATH"` 或重新打开终端 |
| SSH 克隆失败 | 运行 `ssh -T git@github.com` 检查密钥是否已添加 |
| 所有镜像都失败 | 运行 `dl --test` 检查镜像可用性，网络环境可能已变化 |
| 下载超时 | 尝试 `dl --direct <url>` 跳过镜像直连 |
| 权限被拒绝 | 运行 `chmod +x ~/bin/dl` 添加执行权限 |

## 镜像源

| 镜像 | 用途 | 状态 |
|------|------|------|
| ghproxy.cn | Release 文件下载 | 活跃 |
| ghps.cc | Release 文件下载 | 活跃 |
| gh.xmly.dev | Release 文件下载 | 活跃 |

运行 `dl --test` 查看实时测速结果。

## Skill 集成

SDL-HUB 同时提供 AI Agent Skill 文件，可集成到支持 Skill 的 AI 助手中。

将 `skill/` 目录复制到你的 skills 目录即可：

```bash
cp -r skill ~/.agents/skills/dl
```

详见 [skill/SKILL.md](skill/SKILL.md)。

## 项目结构

```
SDL-HUB/
├── dl              # 主脚本
├── install.sh      # 一键安装脚本
├── README.md       # 项目说明
├── LICENSE         # MIT 开源协议
└── skill/
    ├── SKILL.md    # Skill 描述文档
    └── _meta.json  # Skill 元数据
```

## 开源协议

本项目基于 [MIT License](LICENSE) 开源。

## 贡献

欢迎提交 Issue 和 Pull Request！

如果某个镜像源失效了，请提交 Issue 告知，或直接提 PR 更新镜像列表。

