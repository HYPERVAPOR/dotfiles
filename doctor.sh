#!/usr/bin/env bash

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

PASS=0
FAIL=0
WARN=0

check() {
  if [ $1 -eq 0 ]; then
    echo -e "${GREEN}✓${NC} $2"
    ((PASS++))
  else
    echo -e "${RED}✗${NC} $2"
    ((FAIL++))
  fi
}

warn() {
  echo -e "${YELLOW}⚠${NC} $1"
  ((WARN++))
}

echo "========================================"
echo "  Dotfiles Doctor"
echo "========================================"
echo ""

# --- Neovim ---
echo "--- Neovim ---"
nvim --version | head -1 > /dev/null 2>&1
check $? "Neovim installed"

# Check if config loads without errors
nvim --headless -c 'qa' > /dev/null 2>&1
check $? "Neovim config loads without errors"

# Check lazy.nvim
nvim --headless -c 'lua assert(require("lazy.core.config").plugins)"' -c 'qa' > /dev/null 2>&1
check $? "lazy.nvim loaded"

# Check health
nvim --headless -c 'checkhealth' -c 'qa' > /tmp/nvim-checkhealth.txt 2>&1
if grep -q "ERROR" /tmp/nvim-checkhealth.txt; then
  check 1 "checkhealth has errors (see /tmp/nvim-checkhealth.txt)"
else
  check 0 "checkhealth passed"
fi

# --- Symlinks ---
echo ""
echo "--- Symlinks ---"
if [ -L ~/.config/nvim ] && [ -e ~/.config/nvim ]; then
  check 0 "~/.config/nvim -> dotfiles"
elif [ -d ~/.config/nvim ] && [ -d ~/.config/nvim/.git ]; then
  check 0 "~/.config/nvim is the dotfiles repo"
else
  check 1 "~/.config/nvim not linked"
fi

[ -L ~/.zshrc ] && [ -e ~/.zshrc ]
check $? "~/.zshrc linked"

[ -L ~/.tmux.conf ] && [ -e ~/.tmux.conf ]
check $? "~/.tmux.conf linked"

[ -f ~/.zshrc.local ]
check $? "~/.zshrc.local exists"

# --- Tmux ---
echo ""
echo "--- Tmux ---"
tmux -V > /dev/null 2>&1
check $? "tmux installed"

[ -f ~/.tmux.conf ]
check $? "tmux config exists"

[ -d ~/.tmux/plugins/tpm ]
check $? "tpm installed"

# --- Zsh ---
echo ""
echo "--- Zsh ---"
zsh --version > /dev/null 2>&1
check $? "zsh installed"

# --- Git ---
echo ""
echo "--- Git ---"
git --version > /dev/null 2>&1
check $? "git installed"

# Check for sensitive info in repo
echo ""
echo "--- Security Scan ---"
if grep -r "GOOGLE_CLOUD_PROJECT\|API_KEY\|SECRET\|PASSWORD\|TOKEN" --include="*.lua" --include="*.json" --include="*.sh" . 2>/dev/null | grep -v ".git/" | grep -v "\.example" | grep -v "doctor.sh"; then
  check 1 "No sensitive strings found in repo"
else
  check 0 "No sensitive strings found in repo"
fi

# --- LSP / Mason ---
echo ""
echo "--- LSP / Mason ---"
MASON_DIR="$HOME/.local/share/nvim/mason/packages"
[ -d "$MASON_DIR" ]
check $? "Mason directory exists"

for pkg in lua-language-server vtsls; do
  if [ -d "$MASON_DIR/$pkg" ]; then
    check 0 "Mason package: $pkg"
  else
    check 1 "Mason package: $pkg"
  fi
done

# --- Summary ---
echo ""
echo "========================================"
echo -e "  ${GREEN}Pass: $PASS${NC}  ${RED}Fail: $FAIL${NC}  ${YELLOW}Warn: $WARN${NC}"
echo "========================================"

if [ $FAIL -gt 0 ]; then
  echo ""
  echo "Run 'nvim --headless -c checkhealth -c qa' for details."
  exit 1
fi
