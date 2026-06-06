#!/usr/bin/env bash
set -e

DOTFILES="$(cd "$(dirname "$0")" && pwd)"

echo "🔗 Linking dotfiles from $DOTFILES ..."

# Neovim
mkdir -p ~/.config
ln -sf "$DOTFILES" ~/.config/nvim

# Zsh
ln -sf "$DOTFILES/zsh/.zshrc" ~/.zshrc
ln -sf "$DOTFILES/zsh/.p10k.zsh" ~/.p10k.zsh
if [ ! -f "$HOME/.zshrc.local" ]; then
  cp "$DOTFILES/zsh/.zshrc.local.example" ~/.zshrc.local
fi

# Bash
ln -sf "$DOTFILES/bash/.bashrc" ~/.bashrc

# Git
ln -sf "$DOTFILES/git/.gitconfig" ~/.gitconfig

# Tmux
ln -sf "$DOTFILES/tmux/.tmux.conf" ~/.tmux.conf

# Install tpm (Tmux Plugin Manager) if not present
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
