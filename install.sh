#!/usr/bin/env bash
set -e

DOTFILES="$(cd "$(dirname "$0")" && pwd)"
cd "$DOTFILES"

echo "🔗 Stowing dotfiles from $DOTFILES ..."

# 前置检查:GNU Stow
if ! command -v stow >/dev/null 2>&1; then
  echo "✗ GNU Stow 未安装。请先安装:"
  echo "    Debian/Ubuntu (WSL):  sudo apt-get install -y stow"
  echo "    macOS / Linuxbrew:    brew install stow"
  exit 1
fi

# 确保目标目录存在
mkdir -p ~/.config

# 用 Stow 建立软链接:每个顶层子目录(nvim/zsh/tmux/bash/git)是一个 package,
# 其内部结构镜像 $HOME 的相对路径,Stow 会自动算出链接位置。
stow nvim zsh tmux bash git

# 首次安装:从模板创建本地私密配置(被 .gitignore 忽略,不入库)
if [ ! -f "$HOME/.zshrc.local" ]; then
  cp "$DOTFILES/zsh/.zshrc.local.example" ~/.zshrc.local
  echo "✓ 创建 ~/.zshrc.local(从模板,按需填写私密内容)"
fi

# 安装 tpm(Tmux Plugin Manager)
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
  echo "📦 Installing tpm (Tmux Plugin Manager)..."
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

echo "✅ Done!"
echo ""
echo "Next steps:"
echo "  1. Restart your shell or run: source ~/.zshrc"
echo "  2. Start tmux, then press 'Alt+a' then 'I' (capital i) to install tmux plugins"
echo "  3. Inside nvim, run :checkhealth to verify everything is okay"
echo ""
echo "Stow 速查(在 ~/.dotfiles 下执行):"
echo "  建立链接:    stow <package>          (如 stow zsh)"
echo "  移除链接:    stow -D <package>"
echo "  重新全链接:  stow nvim zsh tmux bash git"
