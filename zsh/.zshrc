# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Custom aliases
alias zshconfig="nano ~/.zshrc"
alias ohmyzsh="nano ~/.oh-my-zsh"
alias ll="ls -la"
alias la="ls -A"
alias l="ls -CF"
alias ..="cd .."
alias ...="cd ../.."
alias ~="cd ~"
alias c="clear"
alias gs="git status"
alias ga="git add"
alias gc="git commit"
alias gp="git push"
alias gl="git log --oneline"
alias gd="git diff"
alias gb="git branch"
alias gco="git checkout"
alias pnpm-dev="pnpm dev"
alias pnpm-build="pnpm build"
alias uv-sync="uv sync"
alias npm-to-pnpm="rm -rf node_modules package-lock.json && pnpm install"

# PATH and environment configurations (migrated from .bashrc)

# NVM (Node Version Manager)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Cargo (Rust Package Manager)
. "$HOME/.cargo/env"

# Bun (JavaScript Runtime)
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Local bin
export PATH="$HOME/.local/bin:$PATH"

# Opencode
export PATH="$HOME/.opencode/bin:$PATH"


# Powerlevel10k configuration
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
export PATH=$PATH:/usr/local/go/bin
export EDITOR=nvim
export VISUAL=nvim

# ==========================================
# Clipboard 快捷操作（依赖 win32yank.exe）
# ==========================================

# Alt+c: 复制当前命令行（还没按回车时）
copy-buffer() {
  echo -n "$BUFFER" | win32yank.exe -i --crlf
  zle -M "Copied command to clipboard"
}
zle -N copy-buffer
bindkey '^[c' copy-buffer

# Alt+y: 复制上一条命令本身
# 场景："我刚才跑了个命令，想分享给同事"
copy-last-cmd() {
  fc -ln -1 | sed 's/^[[:space:]]*//' | win32yank.exe -i --crlf
  zle -M "Copied last command to clipboard"
}
zle -N copy-last-cmd
bindkey '^[y' copy-last-cmd

# Alt+o: 复制 tmux 面板最近 30 行（包含命令 + 输出）
# 场景："这条命令的输出我要贴到 issue 里"
copy-output() {
  if [[ -n "$TMUX" ]]; then
    tmux capture-pane -p -S -30 -E - | win32yank.exe -i --crlf
    zle -M "Copied pane output to clipboard"
  else
    zle -M "Not in tmux session"
  fi
}
zle -N copy-output
bindkey '^[o' copy-output

# Alt+Shift+y: 复制上一条命令 + 它的输出（精确版）
# 原理：用 tmux capture-pane 找到最后一条命令所在行，把后面的输出一起复制
copy-cmd-and-output() {
  if [[ -n "$TMUX" ]]; then
    # 获取上条命令文本
    local cmd=$(fc -ln -1 | sed 's/^[[:space:]]*//')
    # 捕获面板内容，找到命令行，把命令+后续输出复制
    local tmp=$(mktemp)
    tmux capture-pane -p -S -100 -E - > "$tmp"
    # 找到命令所在行，复制从该行开始到结尾
    local line=$(grep -n -F "$cmd" "$tmp" | tail -1 | cut -d: -f1)
    if [[ -n "$line" ]]; then
      tail -n +"$line" "$tmp" | win32yank.exe -i --crlf
      zle -M "Copied command + output to clipboard"
    else
      # fallback: 复制最近 20 行
      tail -n 20 "$tmp" | win32yank.exe -i --crlf
      zle -M "Copied last 20 lines to clipboard"
    fi
    rm -f "$tmp"
  else
    zle -M "Not in tmux session"
  fi
}
zle -N copy-cmd-and-output
bindkey '^[Y' copy-cmd-and-output

eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

eval $(thefuck --alias)

# 加载本地敏感配置（不进入 git）
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
