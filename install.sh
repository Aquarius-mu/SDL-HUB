#!/bin/bash
# SDL-HUB 一键安装脚本
set -euo pipefail

INSTALL_DIR="$HOME/bin"
REPO_URL="https://github.com/Aquarius-mu/SDL-HUB"

echo "========================================="
echo "  SDL-HUB 安装程序"
echo "========================================="
echo ""

# 检查依赖
check_deps() {
    local missing=()
    for cmd in git curl ssh; do
        if ! command -v "$cmd" &>/dev/null; then
            missing+=("$cmd")
        fi
    done
    if [[ ${#missing[@]} -gt 0 ]]; then
        echo "错误: 缺少以下依赖: ${missing[*]}"
        echo "请先安装后重试。"
        exit 1
    fi
}

check_deps

# 创建安装目录
mkdir -p "$INSTALL_DIR"

# 下载 dl 脚本
echo "正在下载 dl 脚本..."
if command -v dl &>/dev/null 2>&1; then
    # 已有 dl，用它来下载（利用镜像加速）
    dl --direct --out "$INSTALL_DIR" "${REPO_URL}/raw/main/dl" 2>/dev/null || \
    curl -fsSL -o "$INSTALL_DIR/dl" "${REPO_URL}/raw/main/dl"
else
    curl -fsSL -o "$INSTALL_DIR/dl" "${REPO_URL}/raw/main/dl"
fi

chmod +x "$INSTALL_DIR/dl"

# 确保 ~/bin 在 PATH 中
SHELL_RC="$HOME/.bashrc"
if [[ -n "${ZSH_VERSION:-}" ]]; then
    SHELL_RC="$HOME/.zshrc"
fi

if ! echo "$PATH" | tr ':' '\n' | grep -q "^$HOME/bin$"; then
    echo '' >> "$SHELL_RC"
    echo '# SDL-HUB' >> "$SHELL_RC"
    echo 'export PATH="$HOME/bin:$PATH"' >> "$SHELL_RC"
    export PATH="$HOME/bin:$PATH"
    echo "已将 ~/bin 添加到 PATH"
fi

echo ""
echo "========================================="
echo "  安装完成!"
echo "========================================="
echo ""
echo "使用方法:"
echo "  dl clone <github-url>        # 克隆仓库"
echo "  dl <release-url>             # 下载 Release 文件"
echo "  dl --test                    # 测试镜像速度"
echo "  dl --help                    # 查看帮助"
echo ""
echo "首次使用克隆功能前，请确保已配置 SSH 密钥:"
echo "  1. ssh-keygen -t ed25519"
echo "  2. 将公钥添加到 GitHub: https://github.com/settings/keys"
echo "  3. 配置 SSH 端口 443 (详见 README.md)"
echo ""
